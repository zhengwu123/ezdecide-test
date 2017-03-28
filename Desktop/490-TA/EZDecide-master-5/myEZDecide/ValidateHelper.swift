//
//  ValidateHelper.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 3/5/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit

class ValidateHelper: NSObject {
    
    static func validateEmail(text: String?, sender: UIViewController) -> Bool {
        
        if let email = text {
            if email.isEmpty {
                AlertHelper.alert(alertText: "Please enter an email", sender: sender)
                return false
            } else if !email.contains("@") {
                AlertHelper.alert(alertText: "Please enter a valid email", sender: sender)
                return false
            }
            
            return true
        }
        
        return false
        
    }
    
    static func validatePassword(text: String?, sender: UIViewController) -> Bool {
        
        if let password = text {
            if password.isEmpty {
                AlertHelper.alert(alertText: "Please enter a password", sender: sender)
                return false
            }
            
            return true
        }
        
        return false
        
    }
    
    static func validateConfirmPassword(password: String?, confirmPassword: String?, sender: UIViewController) -> Bool {
        
        if let password = password {
            if password.isEmpty {
                AlertHelper.alert(alertText: "Please enter a password", sender: sender)
                return false
            } else if let confirmPassword = confirmPassword {
                if confirmPassword.isEmpty {
                    AlertHelper.alert(alertText: "Please confirm your password", sender: sender)
                    return false
                } else if password != confirmPassword {
                    AlertHelper.alert(alertText: "Please match your passwords", sender: sender)
                    return false
                }
                
                return true
            }
        }
        
        return false
        
    }
    
    static func validateNewPost(description: String?, option1: String?, option2:String?, hasImage1: Bool, hasImage2: Bool, sender: UIViewController) -> Bool {
        
        if let description = description {
            if description.isEmpty {
                AlertHelper.alert(alertText: "Please enter a description", sender: sender)
                return false
            }
        }
        
        if let option1 = option1 {
            if option1.isEmpty {
                AlertHelper.alert(alertText: "Please enter a title for option 1", sender: sender)
                return false
            }
        }
        
        if !hasImage1 {
            AlertHelper.alert(alertText: "Please select an image for option 1", sender: sender)
            return false
        }
        
        if let option2 = option2 {
            if option2.isEmpty {
                AlertHelper.alert(alertText: "Please enter a title for option 2", sender: sender)
                return false
            }
        }
        
        if !hasImage2 {
            AlertHelper.alert(alertText: "Please select an image for option 2", sender: sender)
            return false
        }
        
        return true
        
    }
    
    static func validateComment(text: String?, sender: UIViewController) -> Bool {
        
        if let text = text {
            
            if text.isEmpty {
                AlertHelper.alert(alertText: "Please enter something", sender: sender)
                return false
            }
            
            return true
        }
        
        return false
        
    }

}
