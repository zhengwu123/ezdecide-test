//
//  PostDetailTableViewCell.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/23/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class PostDetailTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var optionsStackView: UIStackView!
    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet weak var rightStackView: UIStackView!
    @IBOutlet weak var topLeftStackView: UIStackView!
    @IBOutlet weak var bottomLeftStackView: UIStackView!
    @IBOutlet weak var topRightStackView: UIStackView!
    @IBOutlet weak var bottomRightStackView: UIStackView!
    
    @IBOutlet weak var optionsStackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var topLeftImageView: UIImageView!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var bottomLeftImageView: UIImageView!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var topRightImageView: UIImageView!
    @IBOutlet weak var bottomRightButton: UIButton!
    @IBOutlet weak var bottomRightImageView: UIImageView!
    
    var imageDownloader: ImageDownloader!
    
    var cache: NSCache<NSString, AnyObject>!
    
    var fileManager: URL!
    
    var detailViewController: PostDetailViewController!
    
    var mainViewController: MainViewController!
    
    
    var indexPath: IndexPath!
    
    var hasVoted = false
    
    var databaseRef: FIRDatabaseReference!
    
    var photosNum: Int = 0
    
    var post: Post! {
        didSet {
            
            photosNum = 0
            
            descriptionLabel.text = post.postDescription
            
            leftStackView.distribution = .fill
            rightStackView.distribution = .fill
            
            leftStackView.spacing = 10
            rightStackView.spacing = 10
            
            
            bottomLeftButton.isHidden = true
            bottomRightButton.isHidden = true
            
            
            if let optionOneImageUrl = post.optionOneImageUrl {
                
                photosNum += 1
                
                print("imageUrl: \(optionOneImageUrl)")
                // optionOneImageView.image = try! UIImage(data: Data(contentsOf: optionOneImageUrl))
                topLeftButton.setTitle(post.optionOneTitle, for: .normal)
                // topLeftImageView.setImageWith(optionOneImageUrl)
                
                let image1Url = fileManager.appendingPathComponent("\(post.postId)_1.png")
                
                if let image = cache.object(forKey: NSString(string: optionOneImageUrl.absoluteString)) as? UIImage {
                    print("image 1 cached")
                    topLeftImageView.image = image
                } else if let image = UIImage(contentsOfFile: image1Url.path) {
                    print("image 1 was in file system")
                    topLeftImageView.image = image
                    self.cache.setObject(image, forKey: NSString(string: optionOneImageUrl.absoluteString))
                } else {
                    print("Image 1 not cached, download it now")
                    let optionOneUrlRequest = URLRequest(url: optionOneImageUrl)
                    
                    imageDownloader.download(optionOneUrlRequest) { response in
                        
                        if let image = response.result.value {
                            self.topLeftImageView.image = image
                            print("Cache image 1 successfully with identifier \(optionOneImageUrl.absoluteString)")
                            self.cache.setObject(image, forKey: NSString(string: optionOneImageUrl.absoluteString))
                            let imageData = UIImagePNGRepresentation(image)!
                            let image1URL = self.fileManager.appendingPathComponent("\(self.post.postId)_1.png")
                            try! imageData.write(to: image1URL)
                        } else {
                            print("Cache image 1 failed, and stored it in file system")
                        }
                        
                    }
                }
                
            }
            
            if let optionTwoImageUrl = post.optionTwoImageUrl {
                
                photosNum += 1
                
                // optionTwoImageView.image = try! UIImage(data: Data(contentsOf: optionTwoImageUrl))
                print("imageUrl 2: \(optionTwoImageUrl.absoluteString)")
                topRightButton.setTitle(post.optionTwoTitle, for: .normal)
                // topRightImageView.setImageWith(optionTwoImageUrl)
                
                let image2Url = fileManager.appendingPathComponent("\(post.postId)_2.png")
                
                if let image = cache.object(forKey: NSString(string: optionTwoImageUrl.absoluteString)) as? UIImage {
                    print("image 2 cached")
                    topRightImageView.image = image
                } else if let image = UIImage(contentsOfFile: image2Url.path) {
                    print("image 2 was in file system")
                    topRightImageView.image = image
                    self.cache.setObject(image, forKey: NSString(string: optionTwoImageUrl.absoluteString))
                } else {
                    print("Image 2 not cached, download it now")
                    
                    let optionTwoUrlRequest = URLRequest(url: optionTwoImageUrl)
                    
                    imageDownloader.download(optionTwoUrlRequest) { response in
                        
                        if let image = response.result.value {
                            self.topRightImageView.image = image
                            self.cache.setObject(image, forKey: NSString(string: optionTwoImageUrl.absoluteString))
                            let imageData = UIImagePNGRepresentation(image)!
                            let image2URL = self.fileManager.appendingPathComponent("\(self.post.postId)_2.png")
                            try! imageData.write(to: image2URL)
                            print("Cache image 2 successfully, and stored it in file system")
                        }
                        
                    }
                }
            }
            
            
            
            if let optionThreeImageUrl = post.optionThreeImageUrl {
                
                photosNum += 1
                
                rightStackView.spacing = 10
                
                if let optionFourImageUrl = post.optionFourImageUrl {
                    
                    // There are 4 photos
                    photosNum += 1
                    
                    bottomLeftButton.isHidden = false
                    bottomRightButton.isHidden = false
                    
                    leftStackView.distribution = .fillEqually
                    rightStackView.distribution = .fillEqually
                    
                    bottomLeftButton.setTitle(post.optionThreeTitle, for: .normal)
                    // bottomLeftImageView.setImageWith(optionThreeImageUrl)
                    
                    let image3Url = fileManager.appendingPathComponent("\(post.postId)_3.png")
                    
                    if let image = cache.object(forKey: NSString(string: optionThreeImageUrl.absoluteString)) as? UIImage {
                        print("image 3 cached")
                        bottomLeftImageView.image = image
                    } else if let image = UIImage(contentsOfFile: image3Url.path) {
                        print("image 3 was in file system")
                        bottomLeftImageView.image = image
                        self.cache.setObject(image, forKey: NSString(string: optionThreeImageUrl.absoluteString))
                    } else {
                        print("Image 3 not cached, download it now")
                        let optionThreeUrlRequest = URLRequest(url: optionThreeImageUrl)
                        
                        imageDownloader.download(optionThreeUrlRequest) { response in
                            
                            if let image = response.result.value {
                                self.bottomLeftImageView.image = image
                                self.cache.setObject(image, forKey: NSString(string: optionThreeImageUrl.absoluteString))
                                let imageData = UIImagePNGRepresentation(image)!
                                let image3URL = self.fileManager.appendingPathComponent("\(self.post.postId)_3.png")
                                try! imageData.write(to: image3URL)
                                print("Cache image 3 successfully, and stored it in file system")
                            }
                            
                        }
                    }
                    
                    bottomRightButton.setTitle(post.optionFourTitle, for: .normal)
                    // bottomRightImageView.setImageWith(optionFourImageUrl)
                    
                    let image4Url = fileManager.appendingPathComponent("\(post.postId)_4.png")
                    
                    if let image = cache.object(forKey: NSString(string: optionFourImageUrl.absoluteString)) as? UIImage {
                        print("image 4 cached")
                        bottomRightImageView.image = image
                    } else if let image = UIImage(contentsOfFile: image4Url.path) {
                        print("image 4 was in file system")
                        bottomRightImageView.image = image
                        self.cache.setObject(image, forKey: NSString(string: optionFourImageUrl.absoluteString))
                    } else {
                        print("Image 4 not cached, download it now")
                        let optionFourUrlRequest = URLRequest(url: optionFourImageUrl)
                        
                        imageDownloader.download(optionFourUrlRequest) { response in
                            
                            if let image = response.result.value {
                                self.bottomRightImageView.image = image
                                self.cache.setObject(image, forKey: NSString(string: optionFourImageUrl.absoluteString))
                                let imageData = UIImagePNGRepresentation(image)!
                                let image4URL = self.fileManager.appendingPathComponent("\(self.post.postId)_4.png")
                                try! imageData.write(to: image4URL)
                                print("Cache image 4 successfully, and stored it in file system")
                            }
                            
                        }
                    }
                    
                } else {
                    
                    leftStackView.distribution = .fill
                    rightStackView.distribution = .fillEqually
                    leftStackView.spacing = 0
                    
                    bottomRightButton.isHidden = false
                    
                    bottomRightButton.setTitle(post.optionThreeTitle, for: .normal)
                    // bottomRightImageView.setImageWith(optionThreeImageUrl)
                    
                    let image3Url = fileManager.appendingPathComponent("\(post.postId)_3.png")
                    
                    if let image = cache.object(forKey: NSString(string: optionThreeImageUrl.absoluteString)) as? UIImage {
                        print("image 3 cached")
                        bottomRightImageView.image = image
                    } else if let image = UIImage(contentsOfFile: image3Url.path) {
                        print("image 3 was in file system")
                        bottomRightImageView.image = image
                        self.cache.setObject(image, forKey: NSString(string: optionThreeImageUrl.absoluteString))
                    } else {
                        print("Image 3 not cached, download it now")
                        let optionThreeUrlRequest = URLRequest(url: optionThreeImageUrl)
                        
                        imageDownloader.download(optionThreeUrlRequest) { response in
                            
                            if let image = response.result.value {
                                self.bottomRightImageView.image = image
                                self.cache.setObject(image, forKey: NSString(string: optionThreeImageUrl.absoluteString))
                                let imageData = UIImagePNGRepresentation(image)!
                                let image3URL = self.fileManager.appendingPathComponent("\(self.post.postId)_3.png")
                                try! imageData.write(to: image3URL)
                                print("Cached image 3 successfully, and stored it in file system")
                            }
                            
                        }
                    }
                    
                }
                
                
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

            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        databaseRef = FIRDatabase.database().reference()
        
        commentTextField.delegate = self
    }
    
    @IBAction func onOptionButton(_ sender: UIButton) {
        
        let currentPost = self.mainViewController.posts[self.indexPath.row]
        
        var optionId: String?
        
        if sender.superview == topLeftStackView {
            print("topLeftStackView")
            optionId = post.optionOneId
        } else if sender.superview == topRightStackView {
            print("topRightStackView")
            optionId = post.optionTwoId
        } else if sender.superview == bottomLeftStackView {
            print("bottomLeftStackView")
            optionId = post.optionThreeId
        } else if sender.superview == bottomRightStackView {
            print("bottomRightStackView")
            if photosNum == 3 {
                optionId = post.optionThreeId
            } else {
                optionId = post.optionFourId
            }
        }
        
        if sender.backgroundColor != UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1)) {
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to vote for \(sender.currentTitle!)?", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let voteHandler = { (action: UIAlertAction!) -> Void in
                
                if let userVoteId = self.post.userVoteId {
                    let voteRef = self.databaseRef.child("posts").child(self.post.postId!).child("votes").child(userVoteId)
                    
                    
                    voteRef.updateChildValues([
                        "userId": FIRAuth.auth()?.currentUser?.uid,
                        "optionId": optionId
                        ])
                    
                    currentPost.userVoteOptionId = optionId
                    
                    self.deselectAll()
                    
                    sender.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                    
                    self.mainViewController.tableView.reloadData()
                    
                    AlertHelper.alert(alertText: "Successfully updated your vote for \(sender.currentTitle!)", sender: self.mainViewController)
                    
                } else {
                    let voteRef = self.databaseRef.child("posts").child(self.post.postId!).child("votes").childByAutoId()
                    
                    
                    voteRef.setValue([
                        "userId": FIRAuth.auth()?.currentUser?.uid,
                        "optionId": optionId
                        ])
                    
                    
                    currentPost.userVoteOptionId = optionId
                    
                    currentPost.userVoteId = voteRef.key
                    
                    self.deselectAll()
                    
                    sender.backgroundColor = UIColor(red: CGFloat(112/255.0), green: CGFloat(200/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1))
                    
                    self.mainViewController.tableView.reloadData()
                    
                    AlertHelper.alert(alertText: "Successfully voted for \(sender.currentTitle!)", sender: self.mainViewController)
                }
                
            }
            
            let voteAction = UIAlertAction(title: "Vote", style: .default, handler: voteHandler)
            
            alertController.addAction(cancelAction)
            alertController.addAction(voteAction)
            
            mainViewController.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let commentText = commentTextField.text {
            
            if ValidateHelper.validateComment(text: commentText, sender: detailViewController) {
                
                print("Comment: \(commentTextField.text)")
                
                let postRef = databaseRef.child("posts").child(post.postId!)
                
                let commentRef = postRef.child("comments").childByAutoId()
                
                commentRef.setValue([
                    "text": commentText,
                    "userId": FIRAuth.auth()?.currentUser?.uid
                    ])
                
                commentTextField.text = ""
                
                AlertHelper.alert(alertText: "Successfully commented", sender: detailViewController)
                
                detailViewController.post.comments.append([
                    "text": commentText,
                    "userId": FIRAuth.auth()?.currentUser?.uid
                    ])
                
                detailViewController.tableView.reloadData()
            }
    
        }
        
        return true
    }

}
