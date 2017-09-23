//
//  followersCell.swift
//  Instragram
//
//  Created by Harshvardhan Agarwal on 17/08/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit
import Parse

class followersCell: UITableViewCell {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var userNameTxt: UILabel!
    @IBOutlet weak var fallowingBtn: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
      
        avaImg.layer.cornerRadius = avaImg.frame.size.width/2
        avaImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func followBtn_clicked(_ sender: Any) {
        
        let title = fallowingBtn.title(for: UIControlState.normal)
        
        if title == "FOLLOW"{
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username!
            object["following"] = userNameTxt.text
            object.saveInBackground(block: { (success:Bool, error:Error?) in
                
                if success{
                    self.fallowingBtn.setTitle("FOLLOWING", for: UIControlState.normal)
                    self.fallowingBtn.backgroundColor = .green
                }else{
                    print(error!.localizedDescription)
                }
            })
            
        }else{
            let querry = PFQuery(className: "follow")
            querry.whereKey("follower", equalTo: PFUser.current()!.username!)
            querry.whereKey("followinng", equalTo: userNameTxt.text!)
            querry.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                
                if error == nil{
                    
                    for object in objects!{
                        
                        object.deleteInBackground(block: { (success:Bool, error:Error?) in
                            if success{
                              self.fallowingBtn.setTitle("FOLLOW", for: UIControlState.normal)
                                self.fallowingBtn.backgroundColor = UIColor.lightGray
                                
                            }else{
                                print(error!.localizedDescription)
                            }
                            
                        })
                    }
                }else{
                    print(error!.localizedDescription)
                }
            })
            
            
        }
        
        
        
        
    }
    

}
