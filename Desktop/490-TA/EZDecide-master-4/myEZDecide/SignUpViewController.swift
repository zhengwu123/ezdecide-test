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

extension String
{
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    // for convenience we should include String return
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: r.lowerBound)
        let end = self.index(self.startIndex, offsetBy: r.upperBound)
        
        return self[start...end]
    }
}

class SignUpViewController: UIViewController {

    @IBAction func onGenderSelect(_ sender: Any) {
        self.gender = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)
        print(gender)
    }
    @IBOutlet var genderSegment: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    var birthday: String!
    var ZodiacConstellaton: String!
    var month: Int!
    var day: Int!
    var gender: String!
    var username: String!
    var ref: FIRDatabaseReference!
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
                self.birthday = formatedDate.substring(to: index)
            self.birthdayText.text = "\(self.birthday!)"
                var s = self.birthday!
        
                s = s[5..<9]
                self.month = Int(s[0..<1])
                self.day = Int(s[3..<4])
                // Access the string by the range.
             //   let substring = s[r]
               print(s[3..<4])
                self.ZodiacConstellaton = self.Zodiac(month: self.month, day: self.day)
                print(self.ZodiacConstellaton)
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
                    let uid = user?.uid
                     let username = self.usernameTextField.text
                    var urgender:String
                    if(self.gender==nil){
                    urgender = "Male"
                    }
                    else{
                        urgender = self.gender
                    }
                    self.ref = FIRDatabase.database().reference()
                    self.ref.child("users").child((user?.uid)!).setValue(["uid": uid,"username": username,"zodiac":self.ZodiacConstellaton,"birthday":self.birthday,"gender":urgender,"profileimageURL":"defaultIsEmpty"])
                    
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
    func Zodiac(month:Int, day: Int)->String{
        
        switch (month, day) {
        case (3, 21...31), (4, 1...19):
            return "Aries"
        case (4, 20...30), (5, 1...20):
            return "Taurus"
        case (5, 21...31), (6, 1...20):
            return "Gemini"
        case (6, 21...30), (7, 1...22):
            return "Cancer"
        case (7, 23...31), (8, 1...22):
            return "Leo"
        case (8, 23...31), (9, 1...22):
            return "Virgo"
        case (9, 23...30), (10, 1...22):
            return "Libra"
        case (10, 23...31), (11, 1...21):
            return "Scorpio"
        case (11, 22...30), (12, 1...21):
            return "Sagittarius"
        case (12, 22...31), (1, 1...19):
            return "Capricorn"
        case (1, 20...31), (2, 1...18):
            return "Aquarius"
        case (2, 19...29), (3, 1...20):
            return "Pisces"
        default:
            return "Undefined"

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
