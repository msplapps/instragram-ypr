//
//  navVC.swift
//  Instragram
//
//  Created by Harshvardhan Agarwal on 22/09/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit

class navVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName:UIColor.white]
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = UIColor(red: 18/255, green: 86/255, blue: 186/255, alpha: 1)
        
        self.navigationBar.isTranslucent = false

    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
 

}
