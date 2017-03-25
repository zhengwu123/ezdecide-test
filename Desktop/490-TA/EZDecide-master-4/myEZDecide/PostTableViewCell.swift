//
//  PostTableViewCell.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/23/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Firebase
import AFNetworking

class PostTableViewCell: UITableViewCell, UITextFieldDelegate {

    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var optionsStackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var optionsStackView: UIStackView!
    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet weak var rightStackView: UIStackView!
    
    @IBOutlet weak var topLeftStackView: UIStackView!
    @IBOutlet weak var bottomLeftStackView: UIStackView!
    @IBOutlet weak var topRightStackView: UIStackView!
    @IBOutlet weak var bottomRightStackView: UIStackView!
    
    
    var mainViewController: MainViewController!
    
    var indexPath: IndexPath!
    
    var hasVoted = false
    
    var databaseRef: FIRDatabaseReference!
    
    var photosNum: Int = 0
    
    var activeField: UITextField?
    
    var post: Post! {
        didSet {
            
            for view in topLeftStackView.subviews {
                view.removeFromSuperview()
            }
            
            for view in topRightStackView.subviews {
                view.removeFromSuperview()
            }
            
            for view in bottomLeftStackView.subviews {
                view.removeFromSuperview()
            }
            
            for view in bottomRightStackView.subviews {
                view.removeFromSuperview()
            }
            
            photosNum = 0
            
            descriptionLabel.text = post.postDescription
            
            leftStackView.distribution = .fill
            rightStackView.distribution = .fill
            
            leftStackView.spacing = 10
            rightStackView.spacing = 10
            
            let optionOneButton = UIButton(frame: CGRect(x: topLeftStackView.frame.origin.x, y: topLeftStackView.frame.origin.y, width: leftStackView.frame.width,height: 30))
            
            optionOneButton.setTitle(post.optionOneTitle, for: .normal)
            optionOneButton.tintColor = UIColor.white
            optionOneButton.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(130/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
            optionOneButton.setContentHuggingPriority(251, for: .vertical)
            optionOneButton.setContentCompressionResistancePriority(751, for: .vertical)
            optionOneButton.addTarget(self, action: #selector(onOptionOneButton), for: .touchUpInside)
            
            topLeftStackView.addArrangedSubview(optionOneButton)
            
            let optionOneImageView = UIImageView(frame: CGRect(x: topLeftStackView.frame.origin.x, y: topLeftStackView.frame.origin.y, width: leftStackView.frame.width,height: leftStackView.frame.width))
            optionOneImageView.setImageWith(post.optionOneImageUrl!)
            optionOneImageView.contentMode = .scaleAspectFill
            optionOneImageView.setContentHuggingPriority(250, for: .vertical)
            optionOneImageView.setContentCompressionResistancePriority(750, for: .vertical)
            optionOneImageView.clipsToBounds = true
            
            
            topLeftStackView.addArrangedSubview(optionOneImageView)

            
            let optionTwoButton = UIButton(frame: CGRect(x: topRightStackView.frame.origin.x, y: topRightStackView.frame.origin.y, width: rightStackView.frame.width,height: 30))
            
            optionTwoButton.setTitle(post.optionTwoTitle, for: .normal)
            optionTwoButton.tintColor = UIColor.black
            optionTwoButton.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(130/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
            optionTwoButton.setContentHuggingPriority(251, for: .vertical)
            optionTwoButton.setContentCompressionResistancePriority(751, for: .vertical)
            optionTwoButton.addTarget(self, action: #selector(onOptionTwoButton), for: .touchUpInside)
            
            topRightStackView.addArrangedSubview(optionTwoButton)
            
            let optionTwoImageView = UIImageView(frame: CGRect(x: topRightStackView.frame.origin.x, y: topRightStackView.frame.origin.y, width: rightStackView.frame.width,height: rightStackView.frame.width))
            optionTwoImageView.image = UIImage(named: "AppIcon")
            optionTwoImageView.setImageWith(post.optionTwoImageUrl!)
            optionTwoImageView.contentMode = .scaleAspectFill
            optionTwoImageView.setContentHuggingPriority(250, for: .vertical)
            optionTwoImageView.setContentCompressionResistancePriority(750, for: .vertical)
            optionTwoImageView.clipsToBounds = true
            
            topRightStackView.addArrangedSubview(optionTwoImageView)
            
            optionsStackViewHeightConstraint.constant = leftStackView.frame.width + 30
            
            
            
            if let optionOneImageUrl = post.optionOneImageUrl {
                
                photosNum += 1
                
                print("imageUrl: \(optionOneImageUrl)")
                // optionOneImageView.image = try! UIImage(data: Data(contentsOf: optionOneImageUrl))
                // optionOneImageView.setImageWith(optionOneImageUrl)
 
            }
            
            if let optionTwoImageUrl = post.optionTwoImageUrl {
                
                photosNum += 1
                
                // optionTwoImageView.image = try! UIImage(data: Data(contentsOf: optionTwoImageUrl))
                print("imageUrl 2: \(optionTwoImageUrl.absoluteString)")
                // optionTwoImageView.setImageWith(optionTwoImageUrl)
            }
            
            
            
            if post.optionThreeImageUrl != nil {
                
                photosNum += 1
                
                rightStackView.spacing = 10
                
                // Creating optionThreeButton and optionThreeImageView
                let optionThreeButton = UIButton(frame: CGRect(x: topLeftStackView.frame.origin.x, y: topLeftStackView.frame.origin.y, width: leftStackView.frame.width,height: 30))
                
                optionThreeButton.setTitle(post.optionThreeTitle, for: .normal)
                optionThreeButton.tintColor = UIColor.white
                optionThreeButton.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(130/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                optionThreeButton.setContentHuggingPriority(251, for: .vertical)
                optionThreeButton.setContentCompressionResistancePriority(751, for: .vertical)
                optionThreeButton.addTarget(self, action: #selector(onOptionThreeButton), for: .touchUpInside)
                
                bottomLeftStackView.addArrangedSubview(optionThreeButton)
                
                let optionThreeImageView = UIImageView(frame: CGRect(x: topLeftStackView.frame.origin.x, y: topLeftStackView.frame.origin.y, width: leftStackView.frame.width,height: leftStackView.frame.width))
                optionThreeImageView.setImageWith(post.optionThreeImageUrl!)
                optionThreeImageView.contentMode = .scaleAspectFill
                optionThreeImageView.setContentHuggingPriority(250, for: .vertical)
                optionThreeImageView.setContentCompressionResistancePriority(750, for: .vertical)
                optionThreeImageView.clipsToBounds = true
                
                
                if let optionFourImageUrl = post.optionFourImageUrl {
                    
                    // There are 4 photos
                    photosNum += 1
                    
                    leftStackView.distribution = .fillEqually
                    rightStackView.distribution = .fillEqually
                    
                    bottomLeftStackView.addArrangedSubview(optionThreeButton)
                    bottomLeftStackView.addArrangedSubview(optionThreeImageView)
                    
                    
                    // Adding optionFourButton and optionFourImageView
                    let optionFourButton = UIButton(frame: CGRect(x: bottomRightStackView.frame.origin.x, y: bottomRightStackView.frame.origin.y, width: rightStackView.frame.width,height: 30))
                    
                    optionFourButton.setTitle(post.optionFourTitle, for: .normal)
                    optionFourButton.tintColor = UIColor.white
                    optionFourButton.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(130/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                    optionFourButton.setContentHuggingPriority(251, for: .vertical)
                    optionFourButton.setContentCompressionResistancePriority(751, for: .vertical)
                    optionFourButton.addTarget(self, action: #selector(onOptionFourButton), for: .touchUpInside)
                    
                    bottomRightStackView.addArrangedSubview(optionFourButton)
                    
                    let optionFourImageView = UIImageView(frame: CGRect(x: bottomRightStackView.frame.origin.x, y: bottomRightStackView.frame.origin.y, width: rightStackView.frame.width,height: rightStackView.frame.width))
                    optionFourImageView.image = UIImage(named: "AppIcon")
                    optionFourImageView.setImageWith(post.optionFourImageUrl!)
                    optionFourImageView.contentMode = .scaleAspectFill
                    optionFourImageView.setContentHuggingPriority(250, for: .vertical)
                    optionFourImageView.setContentCompressionResistancePriority(750, for: .vertical)
                    optionFourImageView.clipsToBounds = true
                    
                    bottomRightStackView.addArrangedSubview(optionFourImageView)
                    
                    
                    
                } else {
                    
                    leftStackView.distribution = .fill
                    rightStackView.distribution = .fillEqually
                    leftStackView.spacing = 0
                    
                    bottomRightStackView.addArrangedSubview(optionThreeButton)
                    bottomRightStackView.addArrangedSubview(optionThreeImageView)
                    
                }
                
                optionsStackViewHeightConstraint.constant =  2 * (leftStackView.frame.width + 30)
                
                
            } else {
                
               leftStackView.spacing = 0
               rightStackView.spacing = 0
                
            }
            
            
 
             deselectAll()
            
            if let optionId = post.userVoteOptionId {
                
                hasVoted = true
                
                if optionId == post.optionOneId {
                    for view in topLeftStackView.subviews {
                        if view is UIButton {
                            view.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                        }
                    }
                } else if optionId == post.optionTwoId {
                    for view in topRightStackView.subviews {
                        if view is UIButton {
                            view.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                        }
                    }
                }
                
                else if optionId == post.optionThreeId {
                    if photosNum == 4 {
                        for view in bottomLeftStackView.subviews {
                            if view is UIButton {
                                view.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                            }
                        }
                    } else if photosNum == 3 {
                        for view in bottomRightStackView.subviews {
                            if view is UIButton {
                                view.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                            }
                        }
                    }
                } else if optionId == post.optionFourId {
                    for view in bottomRightStackView.subviews {
                        if view is UIButton {
                            view.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                        }
                    }
                }
                
            }
 
 
            // self.layoutIfNeeded()
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        databaseRef = FIRDatabase.database().reference()
        
        commentTextField.delegate = self
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func onOptionOneButton(_ sender: UIButton!) {
        
        print("You pressed option 1 button")
        
        if sender.backgroundColor != UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1)) {
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to vote for \(sender.currentTitle!)?", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let voteHandler = { (action: UIAlertAction!) -> Void in
                
                if let userVoteId = self.post.userVoteId {
                    let voteRef = self.databaseRef.child("posts").child(self.post.postId!).child("votes").child(userVoteId)
                    
                    voteRef.updateChildValues([
                        "userId": FIRAuth.auth()?.currentUser?.uid,
                        "optionId": self.post.optionOneId
                        ])
                    
                    let currentPost = self.mainViewController.posts[self.indexPath.row]
                    
                    currentPost.userVoteOptionId = self.post.optionOneId
                    
                    self.deselectAll()
                    
                    sender.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                    
                    AlertHelper.alert(alertText: "Successfully updated your vote for \(sender.currentTitle!)", sender: self.mainViewController)
                    
                } else {
                    let voteRef = self.databaseRef.child("posts").child(self.post.postId!).child("votes").childByAutoId()
                    
                    voteRef.setValue([
                        "userId": FIRAuth.auth()?.currentUser?.uid,
                        "optionId": self.post.optionOneId
                        ])
                    
                    let currentPost = self.mainViewController.posts[self.indexPath.row]
                    
                    currentPost.userVoteOptionId = self.post.optionOneId
                    
                    
                    self.deselectAll()
                    
                    sender.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                    
                    AlertHelper.alert(alertText: "Successfully voted for \(sender.currentTitle!)", sender: self.mainViewController)
                }
                
            }
            
            let voteAction = UIAlertAction(title: "Vote", style: .default, handler: voteHandler)
            
            alertController.addAction(cancelAction)
            alertController.addAction(voteAction)
            
            mainViewController.present(alertController, animated: true, completion: nil)
            
            
        }
        
    }
    

    func onOptionTwoButton(_ sender: UIButton!) {
        
        print("You pressed option 2 button")
        
        if sender.backgroundColor != UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1)) {
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to vote for \(sender.currentTitle!)?", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let voteHandler = { (action: UIAlertAction!) -> Void in
                
                if let userVoteId = self.post.userVoteId {
                    let voteRef = self.databaseRef.child("posts").child(self.post.postId!).child("votes").child(userVoteId)
                    
                    voteRef.updateChildValues([
                        "userId": FIRAuth.auth()?.currentUser?.uid,
                        "optionId": self.post.optionTwoId
                        ])
                    
                    let currentPost = self.mainViewController.posts[self.indexPath.row]
                    
                    currentPost.userVoteOptionId = self.post.optionTwoId
                    
                    self.deselectAll()
                    
                    sender.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                    
                    AlertHelper.alert(alertText: "Successfully updated your vote for \(sender.currentTitle!)", sender: self.mainViewController)
                    
                } else {
                    let voteRef = self.databaseRef.child("posts").child(self.post.postId!).child("votes").childByAutoId()
                    
                    voteRef.setValue([
                        "userId": FIRAuth.auth()?.currentUser?.uid,
                        "optionId": self.post.optionTwoId
                        ])
                    
                    let currentPost = self.mainViewController.posts[self.indexPath.row]
                    
                    currentPost.userVoteOptionId = self.post.optionTwoId
                    
                    
                    self.deselectAll()
                    
                    sender.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                    
                    AlertHelper.alert(alertText: "Successfully voted for \(sender.currentTitle!)", sender: self.mainViewController)
                }
                
            }
            
            let voteAction = UIAlertAction(title: "Vote", style: .default, handler: voteHandler)
            
            alertController.addAction(cancelAction)
            alertController.addAction(voteAction)
            
            mainViewController.present(alertController, animated: true, completion: nil)
            
            
        }
        
    }

    
    
    func onOptionThreeButton(_ sender: UIButton!) {
        
        print("You pressed option 3 button")
        print("Photos number: \(photosNum)")
        
        if sender.backgroundColor != UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1)) {
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to vote for \(sender.currentTitle!)?", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let voteHandler = { (action: UIAlertAction!) -> Void in
                
                if let userVoteId = self.post.userVoteId {
                    let voteRef = self.databaseRef.child("posts").child(self.post.postId!).child("votes").child(userVoteId)
                    
                    voteRef.updateChildValues([
                        "userId": FIRAuth.auth()?.currentUser?.uid,
                        "optionId": self.post.optionThreeId
                        ])
                    
                    let currentPost = self.mainViewController.posts[self.indexPath.row]
                    
                    currentPost.userVoteOptionId = self.post.optionThreeId
                    
                    self.deselectAll()
                    
                    sender.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                    
                    AlertHelper.alert(alertText: "Successfully updated your vote for \(sender.currentTitle!)", sender: self.mainViewController)
                    
                } else {
                    let voteRef = self.databaseRef.child("posts").child(self.post.postId!).child("votes").childByAutoId()
                    
                    voteRef.setValue([
                        "userId": FIRAuth.auth()?.currentUser?.uid,
                        "optionId": self.post.optionThreeId
                        ])
                    
                    let currentPost = self.mainViewController.posts[self.indexPath.row]
                    
                    currentPost.userVoteOptionId = self.post.optionThreeId
                    
                    
                    self.deselectAll()
                    
                    sender.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                    
                    AlertHelper.alert(alertText: "Successfully voted for \(sender.currentTitle!)", sender: self.mainViewController)
                }
                
            }
            
            let voteAction = UIAlertAction(title: "Vote", style: .default, handler: voteHandler)
            
            alertController.addAction(cancelAction)
            alertController.addAction(voteAction)
            
            mainViewController.present(alertController, animated: true, completion: nil)
            
            
        }
        
    }
    

    func onOptionFourButton(_ sender: UIButton!) {
        
        print("You pressed option 4 button")
        print("Photos number: \(photosNum)")
        
        if sender.backgroundColor != UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1)) {
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to vote for \(sender.currentTitle!)?", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            var optionId: String?
            
            if photosNum == 3 {
                optionId = post.optionThreeId
            } else {
                optionId = post.optionFourId
            }
            
            let voteHandler = { (action: UIAlertAction!) -> Void in
                
                if let userVoteId = self.post.userVoteId {
                    let voteRef = self.databaseRef.child("posts").child(self.post.postId!).child("votes").child(userVoteId)
                    
                    voteRef.updateChildValues([
                        "userId": FIRAuth.auth()?.currentUser?.uid,
                        "optionId": optionId
                        ])
                    
                    let currentPost = self.mainViewController.posts[self.indexPath.row]
                    
                    currentPost.userVoteOptionId = optionId
                    
                    self.deselectAll()
                    
                    sender.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                    
                    AlertHelper.alert(alertText: "Successfully updated your vote for \(sender.currentTitle!)", sender: self.mainViewController)
                    
                } else {
                    let voteRef = self.databaseRef.child("posts").child(self.post.postId!).child("votes").childByAutoId()
                    
                    voteRef.setValue([
                        "userId": FIRAuth.auth()?.currentUser?.uid,
                        "optionId": optionId
                        ])
                    
                    let currentPost = self.mainViewController.posts[self.indexPath.row]
                    
                    currentPost.userVoteOptionId = optionId
                    
                    
                    self.deselectAll()
                    
                    sender.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                    
                    AlertHelper.alert(alertText: "Successfully voted for \(sender.currentTitle!)", sender: self.mainViewController)
                }
                
            }
            
            let voteAction = UIAlertAction(title: "Vote", style: .default, handler: voteHandler)
            
            alertController.addAction(cancelAction)
            alertController.addAction(voteAction)
            
            mainViewController.present(alertController, animated: true, completion: nil)
            
            
        }
        
    }
    
 
    func deselectAll() {
        
        for view in topLeftStackView.subviews {
            if view is UIButton {
                view.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(130/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
            }
        }
        
        for view in topRightStackView.subviews {
            if view is UIButton {
                view.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(130/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
            }
        }
        
        for view in bottomLeftStackView.subviews {
            if view is UIButton {
                view.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(130/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
            }
        }
        
        for view in bottomRightStackView.subviews {
            if view is UIButton {
                view.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(130/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainViewController.isCommenting = true
        
        print("current content offset: \(mainViewController.tableView.contentOffset)")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mainViewController.isCommenting = false
    }
    
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let commentText = commentTextField.text {
            print("Comment: \(commentTextField.text)")
            
            let postRef = databaseRef.child("posts").child(post.postId!)
            
            let commentRef = postRef.child("comments").childByAutoId()
            
            commentRef.setValue([
                "text": commentText,
                "userId": FIRAuth.auth()?.currentUser?.uid
                ])
            
            let currentPost = mainViewController.posts[indexPath.row]
            
            currentPost.comments.append([
                "text": commentText,
                "userId": FIRAuth.auth()?.currentUser?.uid
                ])
            
            commentTextField.text = ""
            
            AlertHelper.alert(alertText: "Successfully commented", sender: mainViewController)
        }
        
        return true
    }
    
    
    

}
