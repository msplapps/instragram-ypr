//
//  PostVC.swift
//  Instragram
//
//  Created by Harshvardhan Agarwal on 21/09/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit
import Parse

var postuuid = [String]()

class PostVC: UITableViewController {
    
    var avarArray = [PFFile]()
    var usernameArray = [String]()
    var dateArray = [Date?]()
    
    var picAray = [PFFile]()
    var uuidArray = [String]()
    var titleArray = [String]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.title = "PHOTO"
        
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backBtn
        
        
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "liked"), object: nil)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 450

        let postQuery = PFQuery(className: "posts")
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        
        postQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            if error == nil {
                //cleanup
                self.avarArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.usernameArray.removeAll(keepingCapacity: false)
                self.picAray.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
                self.titleArray.removeAll(keepingCapacity: false)
                
                //find objects in results
                for object in objects! {
                    
                    self.avarArray.append(object.value(forKey: "ava") as! PFFile)
                    self.dateArray.append(object.createdAt)
                    self.usernameArray.append(object.value(forKey: "username") as! String)
                    self.picAray.append(object.value(forKey: "pic") as! PFFile)
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.titleArray.append(object.value(forKey: "title") as! String)
                }
                
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func refresh(){
        self.tableView.reloadData()
    }

    @IBAction func userNameBtn_clicked(_ sender: Any) {
        
        let i = (sender as! UIButton).layer.value(forKey: "index")
        
        let cell = tableView.cellForRow(at: i as! IndexPath) as! PostVCCell
        
      if cell.userNameBtn.titleLabel?.text == PFUser.current()?.username {
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(homeVC, animated: true)
        
      }else{
        print("Go tot Guest VC")
        
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostVCCell

        // Configure the cell...
        
        cell.userNameBtn.setTitle(usernameArray[indexPath.row], for: UIControlState.normal)
        cell.userNameBtn.sizeToFit()
      //  cell.dateLbl.text = dateArray[indexPath.row]
        cell.titleLbl.text = titleArray[indexPath.row]
        cell.titleLbl.sizeToFit()
        
        cell.uuidLbl.text = uuidArray[indexPath.row]
        
        let avafile = avarArray[indexPath.row]
        avafile.getDataInBackground { (data:Data?, error:Error?) in
             cell.avaImg.image = UIImage(data: data!)
        }
        let picFile = picAray[indexPath.row]
        picFile.getDataInBackground { (data:Data?, error:Error?) in
            cell.picImg.image = UIImage(data: data!)

        }
        
        
////        avarArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
//        
////            cell.avaImg.image = UIImage(data: data!)
////}
//        
//        picAray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
//            
//            cell.picImg.image = UIImage(data: data!)
//        }
        
        //show date
        
        let from = dateArray[indexPath.row]
        let now = Date()
        let components = Set<Calendar.Component>([.second, .minute,.hour,.day,.weekOfMonth])
        let diffrence = Calendar.current.dateComponents(components, from: from!, to: now as Date)
        
        if diffrence.second! < 0 {
            cell.dateLbl.text = "Now"
            
        }
        if diffrence.second! > 0 && diffrence.minute! < 1{
            cell.dateLbl.text = "\(diffrence.second!)s."
        }
        if diffrence.minute! > 0 && diffrence.hour! < 1 {
            cell.dateLbl.text = "\(diffrence.minute!)m."
        }
        if diffrence.hour! > 0 && diffrence.day! < 1 {
            cell.dateLbl.text = "\(diffrence.hour!)h."
        }
        if diffrence.day! > 0 && diffrence.weekOfMonth! < 1 {
            cell.dateLbl.text = "\(diffrence.day!)d."
        }
        if diffrence.weekOfMonth! > 0 {
            cell.dateLbl.text = "\(diffrence.weekOfMonth!)"
        }
        
        let didLike = PFQuery(className: "Likes")
        didLike.whereKey("by", equalTo: PFUser.current()!.username!)
        didLike.whereKey("to", equalTo: cell.uuidLbl.text!)
        didLike.countObjectsInBackground { (count:Int32, error:Error?) in
            if count == 0{
               cell.likeBtn.setTitle("Unlike", for: UIControlState.normal)
                cell.likeBtn.setBackgroundImage(#imageLiteral(resourceName: "Unlike"), for: UIControlState.normal)
                
            }else{
                cell.likeBtn.setTitle("Like", for: UIControlState.normal)
                cell.likeBtn.setBackgroundImage(#imageLiteral(resourceName: "like"), for: UIControlState.normal)
            }
        }
        
        let likesCount = PFQuery(className: "Likes")
        likesCount.whereKey("to", equalTo: cell.uuidLbl.text!)
        likesCount.countObjectsInBackground { (count:Int32, error:Error?) in
            if count > 0 {
                cell.likeLbl.text = "\(count)"
            }else {
               cell.likeLbl.text = "0"
            }
        }
        
        cell.userNameBtn.layer.setValue(indexPath, forKey: "index")
        cell.commentBtn.layer.setValue(indexPath, forKey: "index")

        return cell
    }
    
    @IBAction func commentBtn_clicked(_ sender: Any) {
        
        let i = (sender as! UIButton).layer.value(forKey: "index")
        let cell = tableView.cellForRow(at: i as! IndexPath) as! PostVCCell
        
        commentUUID.append(cell.uuidLbl.text!)
        commentOwner.append((PFUser.current()?.username)!)
        
        let commentVc = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
        
        self.navigationController?.pushViewController(commentVc, animated: true)
        
        
        
    }
    
    
    
    func back(sendr:UIBarButtonItem){
        
        if !uuidArray.isEmpty{
            uuidArray.removeLast()
        }
        
        self.navigationController?.popToRootViewController(animated: true)
        
        
    }




}
