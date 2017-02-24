//
//  PostDetailViewController.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/23/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Firebase

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            
            
            cell.post = self.post
            
            
            cell.selectionStyle = .none
            
            cell.viewController = self
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
