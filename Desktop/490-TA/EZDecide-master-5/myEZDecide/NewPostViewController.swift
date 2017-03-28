//
//  NewPostViewController.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 2/22/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit
import DKImagePickerController
import Firebase
import FirebaseDatabase
import FirebaseStorage
import MBProgressHUD

class NewPostViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var optionOneTextField: UITextField!
    @IBOutlet weak var optionTwoTextField: UITextField!
    @IBOutlet weak var optionThreeTextField: UITextField!
    @IBOutlet weak var optionFourTextField: UITextField!
    
    //Category
    @IBOutlet weak var pickerContentView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    @IBOutlet weak var optionOneImageView: UIImageView!
    @IBOutlet weak var optionTwoImageView: UIImageView!
    @IBOutlet weak var optionThreeImageView: UIImageView!
    @IBOutlet weak var optionFourImageView: UIImageView!
    
    @IBOutlet weak var submitButton: UIButton!
    var optionsCount = 0
    
    var hasSelectImage1 = false
    var hasSelectImage2 = false
    var hasSelectImage3 = false
    var hasSelectImage4 = false
    
    let pickerController = DKImagePickerController()
    
    var databaseRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    var selectedImageView: UIImageView!
    
    var mainViewController: MainViewController!
    
    //Categories
    var categories = ["Activity","Food","Life","Shopping","Study"]
    var categorySelected: String!
    var categoryRowSelected: Int = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Post Your Question"
        
        descriptionTextView.delegate = self
        
        // Make sure the cursor starts from the top of text view
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Initialize pickerController
        pickerController.singleSelect = true
        pickerController.showsCancelButton = true
        
        databaseRef = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
        
        //Rounded corner submit button
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
        
        //PickerView
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerContentView.layer.cornerRadius = 5
        pickerContentView.clipsToBounds = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count == 0 {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
    
    
    @IBAction func onOptionImageView(_ sender: UITapGestureRecognizer) {
        
        selectedImageView = sender.view as! UIImageView
        
        showImagePicker()
        
    }
    
    
    
    func showImagePicker() {
        
        let optionMenu = UIAlertController(title: nil, message: "Where do you want to get your photo?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
            
            let vc = UIImagePickerController()
            vc.delegate = self
            
            vc.sourceType = UIImagePickerControllerSourceType.camera
            
            self.present(vc, animated: true, completion: nil)
            
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action: UIAlertAction) in
            
            let vc = UIImagePickerController()
            vc.delegate = self
            
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            self.present(vc, animated: true, completion: nil)
            
        }
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoLibraryAction)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        if selectedImageView == optionOneImageView {
            hasSelectImage1 = true
            print("Has selected image 1")
        } else if selectedImageView == optionTwoImageView {
            hasSelectImage2 = true
            print("Has selected image 2")
        } else if selectedImageView == optionThreeImageView {
            hasSelectImage3 = true
            print("Has selected image 3")
        } else if selectedImageView == optionFourImageView {
            hasSelectImage4 = true
            print("Has selected image 4")
        }
        
        // Do something with the images (based on your use case)
        selectedImageView.image = originalImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        
    }
    
    func setOptionsCount() {
        if hasSelectImage1 {
            optionsCount += 1
        }
        
        if hasSelectImage2 {
            optionsCount += 1
        }
        
        if hasSelectImage3 {
            optionsCount += 1
        }
        
        if hasSelectImage4 {
            optionsCount += 1
        }
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        if validateInputs() {
            
            // Display HUD right before the request is made
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            print("before set optionsCount: \(optionsCount)")
            
            setOptionsCount()
            
            print("after set optionsCount: \(optionsCount)")
            
            let postRefChild = self.databaseRef.child("posts").childByAutoId()
            postRefChild.setValue([
                "description": descriptionTextView.text!,
                "options": [],
                "category": categorySelected
                ])
            
            let optionOneRefChild = postRefChild.child("options").childByAutoId()
            optionOneRefChild.setValue([
                "image": "",
                "title": optionOneTextField.text!
                ])
            
            let imagesStorageRef = storageRef.child("images")
            
            var data = Data()
            
            data = UIImageJPEGRepresentation(optionOneImageView.image!, 0.1)!
            
            // set upload path
            var filePath = "\(postRefChild.key)/option1.jpg"
            var metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            imagesStorageRef.child(filePath).put(data, metadata: metaData) {
                (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let metaData = metaData {
                    let downloadURL = metaData.downloadURL()!.absoluteString
                    
                    // store downloadURL into database
                    optionOneRefChild.updateChildValues(["image": downloadURL])
                }
            }
            
            
            
            let optionTwoRefChild = postRefChild.child("options").childByAutoId()
            optionTwoRefChild.setValue([
                "image": "",
                "title": optionTwoTextField.text!
                ])
            
            data = Data()
            data = UIImageJPEGRepresentation(optionTwoImageView.image!, 0.1)!
            
            // set upload path
            filePath = "\(postRefChild.key)/option2.jpg"
            metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            imagesStorageRef.child(filePath).put(data, metadata: metaData) {
                (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let metaData = metaData {
                    let downloadURL = metaData.downloadURL()!.absoluteString
                    
                    // store downloadURL into database
                    optionTwoRefChild.updateChildValues(["image": downloadURL])
                }
            }
            
            if optionsCount >= 3 {
                let optionThreeRefChild = postRefChild.child("options").childByAutoId()
                optionThreeRefChild.setValue([
                    "image": "",
                    "title": optionThreeTextField.text!
                    ])
                
                data = Data()
                data = UIImageJPEGRepresentation(optionThreeImageView.image!, 0.1)!
                
                // set upload path
                filePath = "\(postRefChild.key)/option3.jpg"
                metaData = FIRStorageMetadata()
                metaData.contentType = "image/jpeg"
                
                imagesStorageRef.child(filePath).put(data, metadata: metaData) {
                    (metaData, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    if let metaData = metaData {
                        let downloadURL = metaData.downloadURL()!.absoluteString
                        
                        // store downloadURL into database
                        optionThreeRefChild.updateChildValues(["image": downloadURL])
                    }
                }
                
            }
            
            if optionsCount == 4 {
                let optionFourRefChild = postRefChild.child("options").childByAutoId()
                optionFourRefChild.setValue([
                    "image": "",
                    "title": optionFourTextField.text!
                    ])
                
                data = Data()
                data = UIImageJPEGRepresentation(optionFourImageView.image!, 0.1)!
                
                // set upload path
                filePath = "\(postRefChild.key)/option4.jpg"
                metaData = FIRStorageMetadata()
                metaData.contentType = "image/jpeg"
                
                imagesStorageRef.child(filePath).put(data, metadata: metaData) {
                    (metaData, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    if let metaData = metaData {
                        let downloadURL = metaData.downloadURL()!.absoluteString
                        
                        // store downloadURL into database
                        optionFourRefChild.updateChildValues(["image": downloadURL])
                    }
                }
            }
            
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hide(for: self.view, animated: true)
            
            AlertHelper.alertAndExit(alertText: "Successfully made a post", sender: self)
            
        }
        
    }
    
    private func validateInputs() -> Bool {
        
        var result = true
        
        result = ValidateHelper.validateNewPost(description: descriptionTextView.text, option1: optionOneTextField.text, option2: optionTwoTextField.text, hasImage1: hasSelectImage1, hasImage2: hasSelectImage2, sender: self)
        
        return result
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
        
    }
    
    
    //PickerView for categories
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(categories[row])")
        categorySelected = categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = categories[row]
        print("\(titleData)")
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.white])
        categorySelected = categories[categoryRowSelected]
        return myTitle
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
