//
//  CommentCell.swift
//  Instragram
//
//  Created by Harshvardhan Agarwal on 23/09/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
   
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var userNameBtn: UIButton!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        avaImg.translatesAutoresizingMaskIntoConstraints = false
        userNameBtn.translatesAutoresizingMaskIntoConstraints = false
        commentLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        
      
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[userName]-2-[comment]-5-|",
            options: [], metrics: nil, views: ["userName" : userNameBtn,"comment":commentLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[avaimg(40)]",
            options: [], metrics: nil, views: ["avaimg" : avaImg]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[date]",
            options: [], metrics: nil, views: ["date" : dateLbl]))
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[ava(40)]-10-[username]-30-|",
            options: [], metrics: nil, views: ["ava" : avaImg,"username":userNameBtn]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[ava(40)]-10-[comment]-10-|",
            options: [], metrics: nil, views: ["ava" : avaImg,"comment":commentLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[date]-10-|",
            options: [], metrics: nil, views: ["date":dateLbl]))
        
        
        avaImg.layer.cornerRadius = avaImg.frame.size.width/2
        avaImg.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
