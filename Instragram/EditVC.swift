//
//  EditVC.swift
//  Instragram
//
//  Created by Harshvardhan Agarwal on 20/09/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit
import Parse

class EditVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avaImgView: UIImageView!
    
    @IBOutlet weak var fullNameTxtFld: UITextField!
    @IBOutlet weak var useNameTxtFld: UITextField!
    
    @IBOutlet weak var webTxtFld: UITextField!
    
    @IBOutlet weak var bioTxtView: UITextView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var telphoeTxtFld: UITextField!
    @IBOutlet weak var gnderTxtFld: UITextField!
    
    
    var genderPicker:UIPickerView!
    let genders = ["Male","Female"]
    var keyboard = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alignment()
        information()
        
        genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackground
        genderPicker.showsSelectionIndicator = true
        gnderTxtFld.inputView = genderPicker
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(loadImage))
        avaTap.numberOfTapsRequired = 1
        avaImgView.isUserInteractionEnabled = true
        avaImgView.addGestureRecognizer(avaTap)
     
    }
    
    func information(){
        
        let ava = PFUser.current()?.object(forKey: "ava") as! PFFile
        ava.getDataInBackground { (date:Data?, error:Error?) in
            
            self.avaImgView.image = UIImage(data: date!)
        }
        
        fullNameTxtFld.text = PFUser.current()?.object(forKey: "fullname") as? String
        useNameTxtFld.text = PFUser.current()?.username
        bioTxtView.text = PFUser.current()?.object(forKey: "bio") as! String
        webTxtFld.text = PFUser.current()?.object(forKey: "web")as? String
        
        emailTxtFld.text = PFUser.current()?.email
        telphoeTxtFld.text = PFUser.current()?.object(forKey: "tel") as? String
        gnderTxtFld.text = PFUser.current()?.object(forKey: "gender")as? String
        
        
        
    }
    
    func loadImage(reconizer:UITapGestureRecognizer){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func hideKeyBoard(){
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification:Notification){
        
        keyboard = ((notification.userInfo![UIKeyboardFrameEndUserInfoKey]as? NSValue)?.cgRectValue)!
        
        UIView.animate(withDuration: 0.4) {
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height / 2
        }
    }
    
    func keyboardWillHide(notification:Notification){
          keyboard = ((notification.userInfo![UIKeyboardFrameBeginUserInfoKey]as? NSValue)?.cgRectValue)!
        
        UIView.animate(withDuration: 0.4) {
            self.scrollView.contentSize.height = 0
        }
    }
    
    @IBAction func saveBtn_clicked(_ sender: Any) {
        
        if !validateEmail(email: emailTxtFld.text!){
            
            showAlert(error: "Incorrect email", message: "Please enter valid email")
            return
        }
        if !validateWebsite(web: webTxtFld.text!) {
            showAlert(error: "Incorrect web address", message: "Please enter valid web address")
            return
        }
        
        let user = PFUser.current()
        user?.username = useNameTxtFld.text?.lowercased()
        user?.email = emailTxtFld.text?.lowercased()
        user?["fullname"] = fullNameTxtFld.text?.lowercased()
        user?["web"] = webTxtFld.text?.lowercased()
        user?["bio"] = bioTxtView.text
        
        if telphoeTxtFld.text!.isEmpty {
            user?["phone"] = ""
        }else {
            user?["phone"] = telphoeTxtFld.text
        }
        
        if (gnderTxtFld.text?.isEmpty)! {
            user?["gender"] = ""
        }else{
            
            user?["gender"] = gnderTxtFld.text
        }
        
        let avaData = UIImageJPEGRepresentation(avaImgView.image!, 0.5)
        
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user?["ava"] = avaFile
        
        
        user?.saveInBackground(block: { (success:Bool, error:Error?) in
            
            if success {
                
                self.view.endEditing(true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
                self.dismiss(animated: true, completion: nil)

            } else {
                print("\(error?.localizedDescription ?? "ok")")
            }
            
        })
        
        
    }
    
    func showAlert(error:String, message:String) {
        
        let alert = UIAlertController( title: error, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func validateEmail(email:String) -> Bool {
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]"
        let range = email.range(of: regex, options:.regularExpression)
        return range != nil ? true : false
        
    }
    
    func validateWebsite(web:String) -> Bool {
        
        let regex = "www.[A-Z0-9a-z._%+-]+.[A-Za-z]"
        let range = web.range(of: regex, options: .regularExpression)
        return range != nil ? true : false
    }
    
    
    @IBAction func cancelBtn_clicked(_ sender: Any) {
        
        self.view.endEditing(true)
    self.dismiss(animated: true, completion: nil)
    }
    
    
    func alignment(){
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        avaImgView.frame = CGRect(x: width-68-10, y: 10, width: 68, height: 68)
        avaImgView.layer.cornerRadius = avaImgView.frame.size.width/2
        avaImgView.clipsToBounds = true
        
        fullNameTxtFld.frame = CGRect(x: 10, y: avaImgView.frame.origin.y, width: width-avaImgView.frame.size.width - 30, height: 30)
        useNameTxtFld.frame = CGRect(x: 10, y: fullNameTxtFld.frame.origin.y + 40, width: fullNameTxtFld.frame.size.width, height: 30)
        webTxtFld.frame = CGRect(x: 10, y: useNameTxtFld.frame.origin.y + 40, width: width - 20, height: 30)
        
        bioTxtView.frame = CGRect(x: 10, y: webTxtFld.frame.origin.y + 40, width: width - 20, height: 60)
        bioTxtView.layer.borderWidth = 1
        bioTxtView.layer.borderColor = UIColor.gray.cgColor
            // UIColor(red: 230/255.5, green: 230/255.5, blue: 230/255.5, alpha: 1).cgColor
        bioTxtView.layer.cornerRadius = 2
        bioTxtView.clipsToBounds = true
        
        emailTxtFld.frame = CGRect(x: 10, y: bioTxtView.frame.origin.y + 100, width: width - 20, height: 20)
        telphoeTxtFld.frame = CGRect(x: 10, y: emailTxtFld.frame.origin.y + 40, width: width - 20, height: 20)
        gnderTxtFld.frame = CGRect(x: 10, y: telphoeTxtFld.frame.origin.y + 40, width: width-20, height: 20)
        
        titleLbl.frame = CGRect(x: 10, y: emailTxtFld.frame.origin.y - 30, width: width-20, height: 30)
        
        
    }

  
    
    
    //MARK:- PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        gnderTxtFld.text = genders[row]
        self.view.endEditing(true)
    }
    
    
    
    //MARK: - ImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImgView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
}
