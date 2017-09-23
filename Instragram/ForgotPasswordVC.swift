//
//  ForgotPasswordVC.swift
//  Instragram
//
//  Created by Harshvardhan Agarwal on 28/07/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = #imageLiteral(resourceName: "bg-image")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
        
        emailTxtFld.frame = CGRect(x: 10, y: 120, width: self.view.frame.width-20, height: 30)
        resetBtn.frame = CGRect(x: 20, y: emailTxtFld.frame.maxY+20, width: self.view.frame.width/4, height: 30)
        cancelBtn.frame = CGRect(x: self.view.frame.width - self.view.frame.width/4 - 20, y: emailTxtFld.frame.maxY+20, width:  self.view.frame.width/4, height: 30)

    }

 
    @IBAction func resetBt_click(_ sender: Any) {
        
        if(emailTxtFld.text!.isEmpty){
            let alert = UIAlertController(title: "Email Filed", message: "is Empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        PFUser.requestPasswordResetForEmail(inBackground: emailTxtFld.text!) { (success:Bool, error:Error?) in
            
            if success{
                let alert = UIAlertController(title: "email for Reset Password", message: "Sent to texted email", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
                    
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }else{
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelBtn_click(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
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
