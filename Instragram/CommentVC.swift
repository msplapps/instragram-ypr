//
//  CommentVC.swift
//  Instragram
//
//  Created by Harshvardhan Agarwal on 23/09/17.
//  Copyright © 2017 Purushotham. All rights reserved.
//

import UIKit
import Parse

var commentUUID = [String]()
var commentOwner = [String]()

class CommentVC: UIViewController,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentTxt: UITextView!

    @IBOutlet weak var sendBtn: UIButton!
    
    let refresher = UIRefreshControl()
    
    
    var tableViewHeight:CGFloat = 0
    var commetY:CGFloat = 0
    var commentHeight:CGFloat = 0
    
    var keyboard = CGRect()
    var pageSize:Int32 = 15
    
    //tableView
    var avaArray = [PFFile]()
    var userNameArray = [String]()
    var commentArray = [String]()
    var dateArray = [Date?]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       alignment()
        
        self.navigationItem.title = "Comments"
        
        tableView.backgroundColor = UIColor.red
        
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backBtn
        
        
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        sendBtn.isEnabled = false
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        loadComments()
        
    }
    
    func loadComments(){
        
        // count comments
        let countQuery = PFQuery(className: "comments")
        countQuery.whereKey("to", equalTo: commentUUID.last!)
        countQuery.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil{
                
                if count > self.pageSize {
                    
                    self.refresher.addTarget(self, action: #selector(self.loadMore), for: UIControlEvents.valueChanged)
                    self.tableView.addSubview(self.refresher)
                }
            }
            
            // load comments
            let querry = PFQuery(className: "comments")
            querry.whereKey("to", equalTo: commentUUID.last!)
            querry.skip = count - self.pageSize
            querry.addAscendingOrder("createdAt")
            
            querry.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                
                if error == nil {
                    //cleanup
                    self.userNameArray.removeAll(keepingCapacity: false)
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.dateArray.removeAll(keepingCapacity: false)
                    self.avaArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        
                        self.userNameArray.append(object.value(forKey: "username") as! String)
                        self.commentArray.append(object.value(forKey: "comment")as! String)
                        self.dateArray.append(object.createdAt)
                        self.avaArray.append(object.value(forKey: "ava")as! PFFile)
                        self.tableView.reloadData()
                        
                        let index = IndexPath(item: self.commentArray.count-1, section: 0)
                        self.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.bottom, animated: false)
                        
                    }
                    
                    
                }else {
                    print(error?.localizedDescription)
                }
                
            })

        }
       

        
    }
    
    func loadMore(){
        
        
        // count comments
        let countQuery = PFQuery(className: "comments")
        countQuery.whereKey("to", equalTo: commentUUID.last!)
        countQuery.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil{
                  self.refresher.endRefreshing()
                
                if self.pageSize >= count   {
                    
                   self.refresher.removeFromSuperview()
                }
                if self.pageSize < count {
                    
                    self.pageSize = self.pageSize + 15

            // load comments
            let querry = PFQuery(className: "comments")
            querry.whereKey("to", equalTo: commentUUID.last!)
            querry.skip = count - self.pageSize
            querry.addAscendingOrder("createdAt")
            
            querry.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                
                if error == nil {
                    //cleanup
                    self.userNameArray.removeAll(keepingCapacity: false)
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.dateArray.removeAll(keepingCapacity: false)
                    self.avaArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        
                        self.userNameArray.append(object.value(forKey: "username") as! String)
                        self.commentArray.append(object.value(forKey: "comment")as! String)
                        self.dateArray.append(object.createdAt)
                        self.avaArray.append(object.value(forKey: "ava")as! PFFile)
                        self.tableView.reloadData()
                        
                        let index = IndexPath(item: self.commentArray.count-1, section: 0)
                        self.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.bottom, animated: false)
                        
                    }
                    
                    
                }else {
                    print(error?.localizedDescription)
                }
                
            })
            
            }

            
        }
        }
        
        
    }

    
    @IBAction func sendBtn_clicked(_ sender: Any) {
      
        userNameArray.append((PFUser.current()?.username!)!)
        dateArray.append(Date())
        avaArray.append(PFUser.current()?.object(forKey: "ava")as! PFFile)
        commentArray.append(commentTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        tableView.reloadData()
        
        
        let commentObj = PFObject(className: "comments")
        commentObj["to"] = commentUUID.last
        commentObj["username"] = PFUser.current()?.username
        commentObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
        commentObj["comment"] = commentTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        commentObj.saveEventually()
        
        self.tableView.scrollToRow(at: IndexPath(item: commentArray.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
        
        //restore to defalt state
        sendBtn.isEnabled = false
        commentTxt.text = ""
        commentTxt.frame.origin.y = sendBtn.frame.origin.y
        commentTxt.frame.size.height = commentHeight
        tableView.frame.size.height = self.tableViewHeight - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        commentTxt.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func keyboardWillShow(notification:Notification){
        
        keyboard = ((notification.userInfo![UIKeyboardFrameEndUserInfoKey]as? NSValue)?.cgRectValue)!
        
        UIView.animate(withDuration: 0.4) {
 self.tableView.frame.size.height = self.tableViewHeight - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight
            self.commentTxt.frame.origin.y =   self.commentTxt.frame.origin.y - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight
            self.sendBtn.frame.origin.y = self.commentTxt.frame.origin.y
        }
    }
    
    func keyboardWillHide(notification:Notification){
        keyboard = ((notification.userInfo![UIKeyboardFrameBeginUserInfoKey]as? NSValue)?.cgRectValue)!
        
        UIView.animate(withDuration: 0.4) {
            self.tableView.frame.size.height = self.tableViewHeight
            self.commentTxt.frame.origin.y =  self.commetY
            self.sendBtn.frame.origin.y =  self.commetY
        }
    }
    
    func back(){
        if !commentUUID.isEmpty{
            commentUUID.removeLast()
        }
        if !commentOwner.isEmpty{
            commentOwner.removeLast()
        }
        
        self.navigationController?.popToRootViewController(animated: true)
        

    }
    func alignment(){
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        tableView.estimatedRowHeight = width/5.333
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.frame = CGRect(x: 0, y: 0, width: width, height: height/1.096 - (self.navigationController?.navigationBar.frame.size.height)! - 20)
        
        commentTxt.frame = CGRect(x: 10, y: tableView.frame.size.height + height/56.8, width: width/1.306, height: 33)
        commentTxt.layer.cornerRadius = commentTxt.frame.size.width / 50
        
        sendBtn.frame = CGRect(x: commentTxt.frame.size.width + 20, y: commentTxt.frame.origin.y, width: 50, height: 33)
        
        commentTxt.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        tableViewHeight = self.tableView.frame.size.height
        commetY = commentTxt.frame.origin.y
        commentHeight = commentTxt.frame.size.height
        
        
        
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        let space = NSCharacterSet.whitespacesAndNewlines
        
        let text = commentTxt.text.trimmingCharacters(in: space)
        
        if text.isEmpty{
            self.sendBtn.isEnabled = false
        }else{
            self.sendBtn.isEnabled = true
        }
        
        //+ paragrpah
        if textView.contentSize.height > textView.frame.size.height  && textView.frame.size.height < 130 {
            
            let diffrence = textView.contentSize.height - textView.frame.size.height
            
            textView.frame.origin.y = textView.frame.origin.y - diffrence
            textView.frame.size.height = textView.contentSize.height
            // move up tableView
            if textView.frame.size.height + keyboard.height + commetY >= tableView.frame.size.height {
                tableView.frame.size.height = tableView.frame.size.height - diffrence
            }
            
        }
        
        //- Paragraph
        
        if textView.contentSize.height < textView.frame.size.height {
            
            let diffrence = textView.frame.size.height - textView.contentSize.height
   
            
            textView.frame.origin.y = textView.frame.origin.y + diffrence
            textView.frame.size.height = textView.contentSize.height

            if textView.frame.size.height + keyboard.height + commetY >= tableView.frame.size.height {
                tableView.frame.size.height = tableView.frame.size.height + diffrence
            }

            
        }

    }
    
    //MARK:- TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        
        cell.userNameBtn.setTitle(userNameArray[indexPath.row], for: UIControlState.normal)
        cell.commentLbl.text = commentArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            if error == nil{
                cell.avaImg.image = UIImage(data: data!)
            }
        }
        //show date
        
        let from = dateArray[indexPath.row]
        let now = Date()
        let components = Set<Calendar.Component>([.second, .minute,.hour,.day,.weekOfMonth])
        let diffrence = Calendar.current.dateComponents(components, from: from!, to: now as Date)
        
        if diffrence.second! <= 0 {
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

        
    
    return cell
    }
    

}
