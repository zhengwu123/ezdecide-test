//
//  SignUpViewController.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/22/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
class SignUpViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet var birthdayText: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBAction func onBirthdayPicker(_ sender: Any) {
        birthdayText.resignFirstResponder()
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
          var formatedDate: String
            if(date != nil){
            formatedDate = (date?.description)!
                let index = formatedDate.index(formatedDate.startIndex, offsetBy: 10)
                
            self.birthdayText.text = "\(formatedDate.substring(to: index))"
            }
    }
        dismissKeyboard()
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        navigationItem.title = "Sign Up"
        
        //Rounded corner submit button
        signupButton.layer.cornerRadius = 5
        signupButton.clipsToBounds = true
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSignUpButton(_ sender: Any) {
        
        if validateInputs() {
            
            // Display HUD right before the request is made
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if user != nil {
                    print("Successfully signed up")
                    
                    user?.sendEmailVerification(completion: { (error) in
                        
                        AlertHelper.alertAndExit(alertText: "Verification email sent", sender: self)
                        
                    })

                }
            })
        }
        
    }
    
    private func validateInputs() -> Bool {
        
        var result = true
        
        result = ValidateHelper.validateEmail(text: emailTextField.text, sender: self)
        
        result = ValidateHelper.validateConfirmPassword(password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text, sender: self)
        
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
