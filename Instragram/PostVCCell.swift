//
//  PostVCCell.swift
//  Instragram
//
//  Created by Harshvardhan Agarwal on 21/09/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit
import Parse

class PostVCCell: UITableViewCell {
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var userNameBtn: UIButton!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var picImg: UIImageView!
    
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var likeLbl: UILabel!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var uuidLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //Double Tap to Like
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handlelikeTap))
        likeTap.numberOfTapsRequired = 2
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(likeTap)
        
        //allow constraints
        avaImg.translatesAutoresizingMaskIntoConstraints = false
        userNameBtn.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        picImg.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        commentBtn.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        likeLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //set Constraints
        let width = UIScreen.main.bounds.width
        let picWidth = width - 20
        
        
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[ava(30)]-10-[pic(\(picWidth))]-5-[like(30)]",
            options: [], metrics: nil, views:["ava":avaImg,"pic":picImg,"like":likeBtn]))
        
       self.contentView.addConstraints(NSLayoutConstraint.constraints(
        withVisualFormat: "V:|-10-[username]",
        options: [], metrics: nil, views: ["username" : userNameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-15-[date]",
            options: [], metrics: nil, views: ["date" : dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-10-[comment(30)]",
            options: [], metrics: nil, views: ["pic" : picImg,"comment":commentBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic2]-10-[like(30)]",
            options: [], metrics: nil, views: ["pic2" : picImg,"like":likeLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-10-[more(30)]",
            options: [], metrics: nil, views: ["pic" : picImg,"more" : moreBtn]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[ava(30)]-10-[username]",
            options: [], metrics: nil, views: ["ava": avaImg,"username":userNameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic]-10-|",
            options: [], metrics: nil, views: ["pic": picImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[like(30)]-10-[likes(30)]-10-[comment(30)]-20-[more(30)]-10-|",
            options: [], metrics: nil, views: ["like": likeBtn,"likes":likeLbl,"comment":commentBtn,"more":moreBtn]))
        
//        self.contentView.addConstraints(NSLayoutConstraint.constraints(
//            withVisualFormat: "H:[more(30)]-15-|",
//            options: [], metrics: nil, views: ["more" : moreBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[date]-10-|",
            options: [], metrics: nil, views: ["date": dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[like]-5-[note]-5-|",
            options: [], metrics: nil, views: ["like" : likeBtn,"note": titleLbl]))
        
        
        avaImg.layer.cornerRadius = avaImg.frame.size.width/2
        avaImg.clipsToBounds = true
        
    }
    
    func handlelikeTap(){
        print("handleTap")
        let likePic = UIImageView(image: #imageLiteral(resourceName: "like"))
        likePic.frame.size.width = 100
        likePic.frame.size.height = 100
        likePic.center = picImg.center
        likePic.alpha = 0.8
        self.addSubview(likePic)
        
        UIView.animate(withDuration: 0.6) {
            likePic.alpha = 0.0
        //   likePic.removeFromSuperview()
            
        }
        
        
        let title = likeBtn.title(for: UIControlState.normal)
        if title == "Unlike" {
            let object = PFObject(className: "Likes")
            object["by"] = PFUser.current()?.username
            object["to"] = self.uuidLbl.text
            
            object.saveInBackground(block: { (sucess:Bool, error:Error?) in
                if sucess {
                    print("liked")
                    self.likeBtn.setTitle("Like", for: UIControlState.normal)
                    self.likeBtn.setBackgroundImage(#imageLiteral(resourceName: "like"), for: UIControlState.normal)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liked"), object: nil)
                }
            })
        }
        
        
        
    }
    
    @IBAction func likeBtn_clicked(_ sender: Any) {
        
        let title = (sender as! UIButton).title(for: UIControlState.normal)
        
        if title == "Unlike"{
            
            let object = PFObject(className: "Likes")
            object["by"] = PFUser.current()?.username
            object["to"] = self.uuidLbl.text

            object.saveInBackground(block: { (sucess:Bool, error:Error?) in
                if sucess {
                    print("liked")
                    self.likeBtn.setTitle("Like", for: UIControlState.normal)
                    self.likeBtn.setBackgroundImage(#imageLiteral(resourceName: "like"), for: UIControlState.normal)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liked"), object: nil)
                }
                
            })
        }else{
            let query = PFQuery(className: "Likes")
            query.whereKey("to", equalTo: self.uuidLbl.text!)
            query.whereKey("by", equalTo: PFUser.current()!.username!)
            
            query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                
                for object in objects! {
                    
                    object.deleteInBackground(block: { (sucess:Bool, error:Error?) in
                        if sucess{
                            print("disLike")
                            self.likeBtn.setTitle("Unlike", for: UIControlState.normal)
                            self.likeBtn.setBackgroundImage(#imageLiteral(resourceName: "Unlike"), for: UIControlState.normal)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liked"), object: nil)
                            
                        }
                        
                    })
                }
            })
            
        }
        
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
