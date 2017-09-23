//
//  SignInVC.swift
//  Instragram
//
//  Created by Harshvardhan Agarwal on 28/07/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit
import Parse

class SignInVC: UIViewController {
 
    //text Fileds
    @IBOutlet weak var useNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    //Buttons
    @IBOutlet weak var signninBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        titleLbl.frame = CGRect(x: 10, y: 80, width: self.view.frame.size.width-20, height: 50)
        useNameTxtFld.frame = CGRect(x: 10, y: titleLbl.frame.origin.y + 70, width: self.view.frame.width-20, height: 30)
        passwordTxtFld.frame = CGRect(x: 10, y: useNameTxtFld.frame.origin.y + 40, width: self.view.frame.width-20, height: 30)
        forgotBtn.frame = CGRect(x: 10, y: passwordTxtFld.frame.origin.y + 30, width: self.view.frame.width-20, height: 30)
        signninBtn.frame = CGRect(x: 10, y: forgotBtn.frame.origin.y + 40, width:  self.view.frame.width/4, height: 30)
        signUpBtn.frame = CGRect(x: self.view.frame.width - self.view.frame.width/4 - 10, y: forgotBtn.frame.origin.y + 40, width: self.view.frame.width/4, height: 30)
        
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hidekeyboardOnTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = #imageLiteral(resourceName: "bg-image")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        

    }

    
    // user: arora@mystvpn.com
    //pwd: abc@123
    
    
    // abc@gmail.com
   // abc@123
    
    //signin Action
    @IBAction func signInBtn_clicked(_ sender: Any) {
        
        print("signnin clicked")
        self.view.endEditing(true)
        
        if(useNameTxtFld.text!.isEmpty || passwordTxtFld.text!.isEmpty){
            
            let alert = UIAlertController(title: "PlEASE", message: "enter all fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
        PFUser.logInWithUsername(inBackground: useNameTxtFld.text!, password: passwordTxtFld.text!) { (user:PFUser?, error:Error?) in
            if error == nil{
                
                UserDefaults.standard.set(user?.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                
            }else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    
    func hidekeyboardOnTap(reconizer:UITapGestureRecognizer){
        print("keyboard with TapGesture")
        self.view .endEditing(true)
    }
   
}
