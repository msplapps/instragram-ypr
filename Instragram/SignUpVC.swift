//
//  SignUpVC.swift
//  Instragram
//
//  Created by Harshvardhan Agarwal on 28/07/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit
import Parse

class SignUpVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //TextFields
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var repeatPasswordTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    
    @IBOutlet weak var fullNameTxtFld: UITextField!
    @IBOutlet weak var bioTxtFld: UITextField!
    @IBOutlet weak var webTxtFld: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Buttons
    @IBOutlet weak var signnUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    var scrollViewHight:Float = 0.0
    var keyboard = CGRect()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollView Size
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHight = Float(scrollView.frame.height)
        
        //keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        //Add gesture to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hidekeyboardOnTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //Add gesture to load avatar image
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(loadAvatar))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = #imageLiteral(resourceName: "bg-image")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
        
        //alignnment
        
        avaImg.frame = CGRect(x: self.view.frame.width/2 - 40, y: 80, width: 80, height: 80)
        userNameTxtFld.frame = CGRect(x: 10, y: avaImg.frame.maxY+10, width: self.view.frame.width-20, height: 30)
        passwordTxtFld.frame = CGRect(x: 10, y: userNameTxtFld.frame.maxY+10, width: self.view.frame.width-20, height: 30)
        repeatPasswordTxtFld.frame = CGRect(x: 10, y: passwordTxtFld.frame.maxY+10, width: self.view.frame.width-20, height: 30)
        emailTxtFld.frame = CGRect(x: 10, y: repeatPasswordTxtFld.frame.maxY+10, width: self.view.frame.width-20, height: 30)
        
        fullNameTxtFld.frame = CGRect(x: 10, y: emailTxtFld.frame.maxY+40, width: self.view.frame.width-20, height: 30)
        bioTxtFld.frame =  CGRect(x: 10, y: fullNameTxtFld.frame.maxY+10, width: self.view.frame.width-20, height: 30)
        webTxtFld.frame =  CGRect(x: 10, y: bioTxtFld.frame.maxY+10, width: self.view.frame.width-20, height: 30)
        
        signnUpBtn.frame = CGRect(x: 10, y: webTxtFld.frame.maxY+30, width: self.view.frame.width/4, height: 30)
        cancelBtn.frame = CGRect(x: self.view.frame.width - self.view.frame.width/4 - 10 , y: webTxtFld.frame.maxY+30, width: self.view.frame.width/4, height: 30)
        
        
        //make it round image
        
        avaImg.layer.cornerRadius = avaImg.frame.size.width/2
        avaImg.clipsToBounds = true
        
        
   
    }
    
    
    @IBAction func signupBtn_Clicked(_ sender: Any) {
        print("Signup clicked")
        self.view.endEditing(true)
        
        if(userNameTxtFld.text!.isEmpty || passwordTxtFld.text!.isEmpty || repeatPasswordTxtFld.text!.isEmpty||bioTxtFld.text!.isEmpty || emailTxtFld.text!.isEmpty || fullNameTxtFld.text!.isEmpty || webTxtFld.text!.isEmpty){
            
            let alert = UIAlertController(title: "PLEASE", message: "fill all fields", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        if(passwordTxtFld.text != repeatPasswordTxtFld.text){
            
            let alert = UIAlertController(title: "PASSWORDS", message: "do ot match", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    let user = PFUser()
        
        user.email = emailTxtFld.text?.lowercased()
        user.password = passwordTxtFld.text?.lowercased()
        user.username = userNameTxtFld.text?.lowercased()
        
        user["bio"] = bioTxtFld.text
        user["web"] = webTxtFld.text?.lowercased()
        user["fullname"] = fullNameTxtFld.text?.lowercased()
        
        user["phone"] = ""
        user["gender"] = ""
        
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avafile = PFFile(name:"ava.jpg", data: avaData!)
        
        user["ava"] = avafile
        
        //save user details to server
        user.signUpInBackground { (success:Bool, error:Error?) in
            if success{
                print("Registered")
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                delegate.login()
                
                
            }else{
                print(error!.localizedDescription)
            }
        }
        
        
        
    }
    @IBAction func cancelBtn_clicked(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
    }
    
    func loadAvatar(reconizer:UITapGestureRecognizer) {
        print("load avatar")
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    func hidekeyboardOnTap(reconizer:UITapGestureRecognizer){
         print("keyboard with TapGesture")
        self.view .endEditing(true)
    }
    
    func keyboardWillShow(notification:Notification){
        print("keyboard showing")
        keyboard = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        UIView.animate(withDuration: 0.4) { 
            self.scrollView.frame.size.height = CGFloat(self.scrollViewHight - Float(self.keyboard.height))
        }
        
    }
    func keyboardWillHide(notification:Notification){
        print("keyboard hideing")
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.view.frame.height
        }
        
    }
    
 //MARK: - ImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
