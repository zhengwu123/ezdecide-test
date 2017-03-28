//
//  MainViewController.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/22/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseDatabase
import MBProgressHUD
import GoogleSignIn
import Segmentio
import AlamofireImage

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var databaseRef: FIRDatabaseReference!
    
    var posts: [Post]!
    
    var refreshControl: UIRefreshControl!
    
    var isCommenting: Bool = false
    
    var keyboardShown: Bool = false
    
    var cache: NSCache<NSString, AnyObject>?
    
    let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )
    
    let fileManager = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    @IBOutlet weak var filterBar: Segmentio!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    
        navigationItem.title = "Posts"
        
        cache = NSCache<NSString, AnyObject>()
        
        //Add filter bar
        
        
        var content = [SegmentioItem]()
        
        let activityItem = SegmentioItem(
            title: "Activity",
            image: nil
        )
        let foodItem = SegmentioItem(
            title: "Food",
            image: nil
        )
        let lifeItem = SegmentioItem(
            title: "Life",
            image: nil
        )
        let shopItem = SegmentioItem(
            title: "Shopping",
            image: nil
        )
        let studyItem = SegmentioItem(
            title: "Study",
            image: nil
        )
        content.append(activityItem)
        content.append(foodItem)
        content.append(lifeItem)
        content.append(shopItem)
        content.append(studyItem)
        
        let indic_opt = SegmentioIndicatorOptions(
            type: .bottom,
            ratio: 1,
            height: 5,
            color: UIColor(red: 211/255.0, green: 214/255.0, blue: 144/255.0, alpha: 1)
        )
        
        let hori_opt = SegmentioHorizontalSeparatorOptions(
            type: SegmentioHorizontalSeparatorType.topAndBottom, // Top, Bottom, TopAndBottom
            height: 1,
            color: .gray
        )
        
        let verti_opt = SegmentioVerticalSeparatorOptions(
            ratio: 0.6, // from 0.1 to 1
            color: .gray
        )
        
        let states = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .black
            ),
            selectedState: SegmentioState(
                backgroundColor: UIColor(red: 211/255.0, green: 214/255.0, blue: 144/255.0, alpha: 1),
                titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .white
            ),
            highlightedState: SegmentioState(
                backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .black
            )
        )
        
        let opts = SegmentioOptions(
            backgroundColor: .white,
            maxVisibleItems: 3,
            scrollEnabled: true,
            indicatorOptions: indic_opt,
            horizontalSeparatorOptions: hori_opt,
            verticalSeparatorOptions: verti_opt,
            imageContentMode: .center,
            labelTextAlignment: .center,
            labelTextNumberOfLines : 0,
            segmentStates: states,
            animationDuration : 0.1
            
        )
        filterBar.setup(
            content: content,
            style: SegmentioStyle.onlyLabel,
            options: opts
            
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        databaseRef = FIRDatabase.database().reference()
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        doSearch()
    }

    override func viewWillAppear(_ animated: Bool) {
        // doSearch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if !keyboardShown {
                self.view.frame.origin.y -= keyboardSize.height
                print(keyboardSize.height)
                keyboardShown = true
            }
        }
        
    }
    
    func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardShown {
                self.view.frame.origin.y += keyboardSize.height
                print(keyboardSize.height)
                keyboardShown = false
            }
        }
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        doSearch()
        
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        
        if (FBSDKAccessToken.current() != nil) {
            print("Try to sign out with FB")
            FBSDKLoginManager().logOut()
        }
        
        if (GIDSignIn.sharedInstance().currentUser != nil) {
            print("Try to sign out with Google")
            GIDSignIn.sharedInstance().signOut()
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogoutNotification"), object: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if posts != nil {
            return posts.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        cell.imageDownloader = imageDownloader
        
        cell.cache = cache
        
        cell.fileManager = fileManager
        
        if (self.posts[indexPath.row] as? Post) != nil {
            cell.post = self.posts[indexPath.row]
        }
        
        cell.selectionStyle = .none
        
        cell.mainViewController = self
        
        cell.indexPath = indexPath
        
        return cell
    }
    
    func doSearch() {
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        databaseRef.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            
            if let posts = snapshot.value as? NSDictionary {
                
                var dictionaries: [NSDictionary] = []
                
                for post in posts {
                    dictionaries.append([post.key : post.value])
                }
                
                self.posts = Post.postsWithArray(dictionaries: dictionaries)
                
                self.tableView.reloadData()
                
                self.refreshControl?.endRefreshing()
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        })

    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isCommenting {
            print("It is commenting")
            self.view.endEditing(true)
            return false
        } else {
            print("It is not commenting")
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {

            self.view.endEditing(true)
            
            let cell = sender as! PostTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            
            print(indexPath!.row)
            print("Post: \(posts![indexPath!.row])")
            
            let post = posts![indexPath!.row]
            
            let detailViewController = segue.destination as! PostDetailViewController
            
            detailViewController.fileManager = fileManager
            
            detailViewController.imageDownloader = imageDownloader
            
            detailViewController.cache = cache
            
            detailViewController.post = post
            
            detailViewController.navigationItem.title = "Post Detail"
            
            detailViewController.mainViewController = self
            
            detailViewController.indexPath = indexPath
        
            // Deselect collection view after segue
            self.tableView.deselectRow(at: indexPath!, animated: true)
            
        } else if segue.identifier == "composeSegue" {
            
            let newPostViewController = segue.destination as! NewPostViewController
            
            newPostViewController.mainViewController = self
            
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
