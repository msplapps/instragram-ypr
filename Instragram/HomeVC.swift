//
//  HomeVC.swift
//  Instragram
//
//  Created by Harshvardhan Agarwal on 10/08/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit
import Parse


class HomeVC: UICollectionViewController {
    
    var refresher:UIRefreshControl!
    
    var page:Int = 10
    var uuidArray = [String]()
    var picArray = [PFFile]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            collectionView?.backgroundColor = UIColor.white
        self.navigationItem.title = PFUser.current()?.username?.uppercased()
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView?.addSubview(refresher)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(upload), name: NSNotification.Name(rawValue: "uploaded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        
        loadPosts()
        
        
        
    }


    func refresh(){
      collectionView?.reloadData()
       refresher.endRefreshing()
        
    }
    
    func refreshData(notification:Notification){
        
        collectionView?.reloadData()

    }
    
    func upload(){
        loadPosts()
    }
    func loadPosts(){
        
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.limit = page
        query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                   self.uuidArray.append(object.value(forKey: "uuid") as! String)
                   self.picArray.append(object.value(forKey: "pic") as! PFFile)
                    
                }
                self.collectionView?.reloadData()
                
            } else {
                print("Error:", error!.localizedDescription)
            }
            
            
        }
        
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height {
            loadMore()
        }
    }
    
    func loadMore(){
        
        
        if page <= picArray.count {
            
            page = page + 12
            print("Loaded:",page)
            loadPosts()
            
        }
        
        
    }

    
    // MARK: UICollectionViewDataSource

 
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
       
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
        
        header.fullNameLbl.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.webTxt.text = PFUser.current()?.object(forKey: "web") as? String
        header.webTxt.sizeToFit()
        header.bioLbl.text = PFUser.current()?.object(forKey: "bio") as? String
        header.webTxt.sizeToFit()
        
        header.button.setTitle("Edit Profile", for: UIControlState.normal)
        
        let avaQuery = PFUser.current()?.object(forKey: "ava") as? PFFile
        
        avaQuery?.getDataInBackground(block: { (data:Data?, error:Error?) in
            if data != nil{
                header.avaImg.image = UIImage(data: data!)
            }
        })
        
        // Calulate statistics
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: PFUser.current()!.username!)
        posts.countObjectsInBackground { (count:Int32, error:Error?) in
            
            if error == nil {
                header.posts.text = "\(count)"
            }
        }
        
        //Add Geatures
        
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(handlePostsTap))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(handlefollowersTap))
        followersTap.numberOfTapsRequired = 1
        header.fallowers.isUserInteractionEnabled = true
        header.fallowers.addGestureRecognizer(followersTap)
        
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(handlefollowingsTap))
        followingsTap.numberOfTapsRequired = 1
        header.fallowings.isUserInteractionEnabled = true
        header.fallowings.addGestureRecognizer(followingsTap)
        
        
        return header
    }

    func handlePostsTap(){
         print("handlePostsTap")
        if !picArray.isEmpty{
            
            let index = IndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.top, animated: true)
        }
        
    }
    
    func handlefollowersTap(){
        print("handlefollowersTap")
        
        
        let followersVC = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as? FollowersVC
        
        followersVC?.user = PFUser.current()!.username!
        followersVC?.show = "followers"
        
        self.navigationController?.pushViewController(followersVC!, animated: true)
        
    }
    func handlefollowingsTap(){
        
           print("handlefollowingTap")
        let followingVC = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as? FollowersVC
        
        followingVC?.user = PFUser.current()!.username!
        followingVC?.show = "followings"
        
        self.navigationController?.pushViewController(followingVC!, animated: true)
        
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
      //   return 20
    }
    

 

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        

       // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        
        
         cell.picImg.image = #imageLiteral(resourceName: "ForgotPwd")
        
  
       picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
        
            if error == nil {
                
               cell.picImg.image = UIImage(data: data!)
               
                
            } else {
                print("Error:", error!.localizedDescription)
            }
        }
     
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        postuuid.append(uuidArray[indexPath.row])
        
        let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
        self.navigationController?.pushViewController(postVC, animated: true)
        
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
