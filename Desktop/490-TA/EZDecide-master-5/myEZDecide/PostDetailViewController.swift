//
//  PostDetailViewController.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/23/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentToolView: UIView!
    
    @IBOutlet weak var commentTextField: UITextField!

    
    @IBOutlet weak var commentToolViewToBottomConstraint: NSLayoutConstraint!
    
    
    var cache: NSCache<NSString, AnyObject>!
    
    var imageDownloader: ImageDownloader!
    
    var fileManager: URL!
    
    var mainViewController: MainViewController!
    
    var indexPath: IndexPath!
    
    var post: Post!
    
    var keyboardShown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentToolView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        print("mainViewController: \(mainViewController)")
        print("indexPath: \(indexPath)")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView(frame: CGRect.zero)
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
                commentToolView.isHidden = true
                print(keyboardSize.height)
                keyboardShown = false
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            print(post.comments.count)
            return post.comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailCell", for: indexPath) as! PostDetailTableViewCell
            
            cell.imageDownloader = imageDownloader
            
            cell.fileManager = fileManager
            
            cell.cache = cache
            
            cell.post = self.post
            
            cell.selectionStyle = .none
            
            cell.detailViewController = self
            
            cell.mainViewController = self.mainViewController
            
            cell.indexPath = self.indexPath
            
            print("indexPath.row: \(self.indexPath.row)")
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
            
            let comment = post.comments[indexPath.row]
            
            if let text = comment["text"] as? String {
                cell.commentLabel.text = text
            }
            
            if let userId = comment["userId"] as? String {
                cell.usernameLabel.text = userId
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        commentToolView.isHidden = false
        commentToolViewToBottomConstraint.constant = 0
        commentTextField.becomeFirstResponder()
        
        let comment = post.comments[indexPath.row]
        
        if let userId = comment["userId"] as? String {
            commentTextField.placeholder = "@\(userId)"
        }
        
    }
    
    
    @IBAction func onTapDetailCell(_ sender: UITapGestureRecognizer) {
        
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
