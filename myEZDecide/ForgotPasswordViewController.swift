//
//  ForgotPasswordViewController.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/22/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Forgot Password"
        
        //Rounded corner submit button
        resetButton.layer.cornerRadius = 5
        resetButton.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onForgotPasswordButton(_ sender: Any) {
        
        if validateInputs() {
            
            // Display HUD right before the request is made
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: emailTextField.text!, completion: { (error) in
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let error = error {
                    AlertHelper.alert(alertText: "User does not exist", sender: self)
                    return
                }
                
                AlertHelper.alertAndExit(alertText: "Email sent successfully", sender: self)
                
            })
        }

    }
    
    private func validateInputs() -> Bool {
        
        var result = true
        
        result = ValidateHelper.validateEmail(text: emailTextField.text, sender: self)
        
        return result
    }
    
    
    @IBAction func onTapView(_ sender: UITapGestureRecognizer) {
        
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
