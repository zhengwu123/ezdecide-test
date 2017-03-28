//
//  Post.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/23/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Firebase

class Post: NSObject {
    
    var postId: String?
    var optionOneId: String?
    var optionTwoId: String?
    var optionThreeId: String?
    var optionFourId: String?
    
    var votes: NSDictionary?
    var comments: [NSDictionary]! = []
    
    var userVoteOptionId: String?
    var userVoteId: String?
    
    var hasVoted: Bool = false
    
    var postDescription: String?
    var optionOneTitle: String?
    var optionTwoTitle: String?
    var optionThreeTitle: String?
    var optionFourTitle: String?
    var optionOneImageUrl: URL?
    var optionTwoImageUrl: URL?
    var optionThreeImageUrl: URL?
    var optionFourImageUrl: URL?
    
    var count = 0
    
    init(dictionary: NSDictionary) {
        
        for (key, val) in dictionary {
            
            postId = key as? String
            
            if let post = val as? NSDictionary {
                postDescription = post["description"] as? String
                
                votes = post["votes"] as? NSDictionary
                
                if let votes = votes {
                    for (voteKey, voteVal) in votes {
                        if let vote = voteVal as? NSDictionary {
                            
                            let optionId = vote["optionId"] as!String
                            
                            let userId = vote["userId"] as! String
                            
                            if FIRAuth.auth()?.currentUser?.uid == userId {
                                
                                self.userVoteOptionId = optionId
                                
                                self.userVoteId = voteKey as? String
                            }
                            
                        }
                    }
                }
                
                let commentsTemp = post["comments"] as? NSDictionary
                
                if let commentsTemp = commentsTemp {
                    for (commentKey, commentVal) in commentsTemp {
                        if let comment = commentVal as? NSDictionary {
                            
                            let text = comment["text"] as! String
                            let userId = comment["userId"] as! String
                            
                            self.comments.append([
                                "text": text,
                                "userId": userId
                                ])
                            
                            print(self.comments)
                        }
                    }
                }
                
                if let options = post["options"] as? NSDictionary {
                    for (optionKey, optionVal) in options {

                        if let option = optionVal as? NSDictionary {
                            
                            if self.count == 0 {
                                self.optionOneId = optionKey as? String
                                
                                print("option: \(option)")
                                
                                self.optionOneTitle = option["title"] as? String
                                self.optionOneImageUrl = URL(string: (option["image"] as? String)!)
                            } else if count == 1 {
                                self.optionTwoId = optionKey as? String
                                
                                self.optionTwoTitle = option["title"] as? String
                                self.optionTwoImageUrl = URL(string: (option["image"] as? String)!)
                            } else if count == 2 {
                                self.optionThreeId = optionKey as? String
                                
                                self.optionThreeTitle = option["title"] as? String
                                self.optionThreeImageUrl = URL(string: (option["image"] as? String)!)
                            } else if count == 3 {
                                self.optionFourId = optionKey as? String
                                
                                self.optionFourTitle = option["title"] as? String
                                self.optionFourImageUrl = URL(string: (option["image"] as? String)!)
                            }
                            
                        }
                        
                        self.count += 1
                        
                    }
                }
            }
            
            
        }
    }
    
    class func postsWithArray(dictionaries: [NSDictionary]) -> [Post] {
        var posts = [Post]()
        
        for dictionary in dictionaries {
            let post = Post(dictionary: dictionary)
            
            posts.append(post)
        }
        
        return posts
        
    }
    
}
