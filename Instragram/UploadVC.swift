//
//  UploadVC.swift
//  Instragram
//
//  Created by Harshvardhan Agarwal on 16/08/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit
import Parse

class UploadVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextView!
    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        publishBtn.isEnabled = false
        publishBtn.backgroundColor = UIColor.lightGray
        
        
        picImg.image = #imageLiteral(resourceName: "pp")
       
        
        removeBtn.isHidden = true
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hidekeyboardOnTap))
        hideTap.numberOfTapsRequired = 1
        self.view .isUserInteractionEnabled = true
        self.view .addGestureRecognizer(hideTap)
        
        let picTap = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        picTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(picTap)

    }

    override func viewWillAppear(_ animated: Bool) {
        alignment()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func alignment(){
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        picImg.frame = CGRect(x: 15, y: 15, width: width/4.5, height: width/4.5)
        titleTxt.frame = CGRect(x: picImg.frame.size.width+30, y: picImg.frame.origin.y, width: (width - titleTxt.frame.origin.x) - 15, height: picImg.frame.size.height)
        publishBtn.frame = CGRect(x: 0, y: height/1.09, width: width, height: width/8)
        
        removeBtn.frame = CGRect(x:picImg.frame.origin.x, y: picImg.frame.origin.y + picImg.frame.size.height, width:picImg.frame.size.width, height:20)
        
    }
    
    func hidekeyboardOnTap(){
       self.view.endEditing(true)
    }
    func selectImage(){
     
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
}
    
    @IBAction func publishBtn_clicked(_ sender: Any) {
        self.view.endEditing(true)
        
        let object = PFObject(className: "posts")
        object["username"] = PFUser.current()?.username
        object["ava"] = PFUser.current()?.value(forKey: "ava") as? PFFile
        let userName = PFUser.current()?.username
        object["uuid"] = "\(userName!) \(NSUUID().uuidString)"
        
        if titleTxt.text.isEmpty {
            object["title"] = ""
        }else {
            object["title"] = titleTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        let imagedata = UIImageJPEGRepresentation(picImg.image!, 0.5)
        let imageFile = PFFile(name: "post.jpg", data: imagedata!)
        
        object["pic"] = imageFile
        
        object.saveInBackground { (success:Bool, error:Error?) in
            
            if error != nil {
                print(error.debugDescription)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploaded"), object: nil)
                self.tabBarController?.selectedIndex = 0
                 self.titleTxt.text = ""
                self.viewDidLoad()
            }
            
        }
        
        
    }
    
    
    @IBAction func removeBtn_Clicked(_ sender: Any) {
       self.viewDidLoad()
        
    }
    
    
     // MARK: - PickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        self.publishBtn.isEnabled = true
        self.publishBtn.backgroundColor = .green
        
        removeBtn.isHidden = false
        
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(zoomImage))
        zoomTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(zoomTap)
    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func zoomImage(){
        
        let zoomed = CGRect(x: 0, y: self.view.center.y-self.view.center.x - self.tabBarController!.tabBar.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        let unZoomed = CGRect(x: 15, y: 15, width: self.view.frame.size.width/4.5, height: self.view.frame.size.width/4.5)
        
        if picImg.frame == unZoomed{
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.picImg.frame = zoomed
                self.view.backgroundColor = .black
                self.titleTxt.alpha = 0
                self.publishBtn.alpha = 0
                self.removeBtn.alpha = 0
            })
        }else{
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.picImg.frame = unZoomed
                self.view.backgroundColor = .white
                self.titleTxt.alpha = 1
                self.publishBtn.alpha = 1
                 self.removeBtn.alpha = 1
            })
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
