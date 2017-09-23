//
//  FollowersVC.swift
//  Instragram
//
//  Created by Harshvardhan Agarwal on 17/08/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit
import Parse



class FollowersVC: UITableViewController {
    
    var show:String = ""
    var user:String = ""
    
    var userameArray = [String]()
    var avaImageArray = [PFFile]()
    
    var fallowArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = show.uppercased()
        
        if show == "Followings"{
            loadFollowings()
         }
        if show == "followers"{
            loadFollowers()
        }
    }

    func loadFollowers(){
        
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("following", equalTo: user)
        followQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            if error == nil{
                 self.fallowArray.removeAll(keepingCapacity: false)
                for object in objects!{
                    self.fallowArray.append(object.value(forKey: "follower") as! String)
                }
                
               let query = PFUser.query()
                query?.whereKey("username", containedIn: self.fallowArray)
                query?.addDescendingOrder("createdAt")
                query?.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                    
                    if error == nil{
                        self.userameArray.removeAll(keepingCapacity: false)
                        self.avaImageArray.removeAll(keepingCapacity: false)
                        
                        for object in objects!{
                          self.userameArray.append(object.value(forKey: "username") as! String)
                          self.avaImageArray.append(object.value(forKey: "ava")as! PFFile)
                            self.tableView.reloadData()
                        }
                    }else{
                        print(error!.localizedDescription)
                    }
                })
                
            }else{
                print(error!.localizedDescription)
            }
            
            
        }
        
    }
    
    
    func loadFollowings(){
        
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: user)
        followQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            if error == nil{
                
                self.fallowArray.removeAll(keepingCapacity: false)
                for object in objects!{
                    self.fallowArray.append(object.value(forKey: "following")as! String)
                }
                let query = PFQuery(className: "_User")
                query.whereKey("username", containedIn: self.fallowArray)
                query.addDescendingOrder("createAt")
                query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                    if error == nil{
                        self.fallowArray.removeAll(keepingCapacity: false)
                        self.avaImageArray.removeAll(keepingCapacity: false)
                        
                        for  object in objects! {
                            self.fallowArray.append(object.value(forKey: "username")as! String)
                            self.avaImageArray.append(object.value(forKey: "ava")as! PFFile)
                            self.tableView.reloadData()
                        }
                        
                    }else{
                        print(error!.localizedDescription)
                    }
                    
                })
            }else{
                print(error!.localizedDescription)
            }
        }
        
    }
    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userameArray.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! followersCell
        
        cell.userNameTxt.text = userameArray[indexPath.row]
        avaImageArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil{
                 cell.avaImg.image = UIImage(data: data!)
            }else{
                print(error!.localizedDescription)
            }
        }
        
        let query = PFQuery(className: "follow")
        query.whereKey("follower", equalTo: user)
        query.whereKey("following", equalTo: cell.userNameTxt.text!)
        query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            if error != nil{
                if objects?.count == 0 {
                    
                    cell.fallowingBtn.setTitle("FOLLOW", for: UIControlState.normal)
                    cell.fallowingBtn.backgroundColor = UIColor.lightGray
                    
                }else{
                    
                    cell.fallowingBtn.setTitle("FOLLOWING", for: UIControlState.normal)
                    cell.fallowingBtn.backgroundColor = UIColor.green
                }
            }else{
                print(error!.localizedDescription)
            }
        }
        
        
        if cell.userNameTxt.text == user{
            cell.fallowingBtn.isHidden = true
        }
        return cell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
