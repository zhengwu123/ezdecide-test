//
//  ViewController.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/22/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import MBProgressHUD
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //Rounded corner for every button
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
        facebookButton.layer.cornerRadius = 5
        facebookButton.clipsToBounds = true
        googleButton.layer.cornerRadius = 5
        googleButton.clipsToBounds = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func onLoginWithEmailButton(_ sender: Any) {
        
        if validateInputs() {
            // Display HUD right before the request is made
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let error = error {
                    AlertHelper.alert(alertText: "Failed to login", sender: self)
                    print(error.localizedDescription)
                }
                
                if let user = user {
                    print("Successfully logged in")
                    
                    if !user.isEmailVerified {
                        AlertHelper.alert(alertText: "Please verify your email before login", sender: self)
                    }
                    
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                
            }
        }
        
    }
    
    @IBAction func onLoginWithFacebookButton(_ sender: Any) {
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager.init()
        
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                if let result = result {
                    if (result.isCancelled) {
                        print("Login with Facebook was cancelled 2")
                    } else {
                        print("Successfully logged in with Facebook 2")
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                } else {
                    print("Failed to login with facebook 2")
                    return
                }
            }
        }
    }
    
    @IBAction func onLoginWithGoogleButton(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    private func validateInputs() -> Bool {
        
        var result = true
        
        result = ValidateHelper.validateEmail(text: emailTextField.text, sender: self)
        
        result = ValidateHelper.validatePassword(text: passwordTextField.text, sender: self)
        
        return result
        
    }
    
    
    @IBAction func onTapView(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
        
    }
    
    
}

