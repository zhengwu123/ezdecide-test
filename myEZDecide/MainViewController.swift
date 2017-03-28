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

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var databaseRef: FIRDatabaseReference!
    
    var posts: [Post]!
    
    var refreshControl: UIRefreshControl!
    
    var isCommenting: Bool = false
    
    var keyboardShown: Bool = false
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    
        navigationItem.title = "Posts"
        
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
