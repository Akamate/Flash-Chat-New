//
//  ViewController.swift
//  Flash Chat
//
//  Created by Akamate on 18/11/2018.
//  Copyright (c) 2018 Akamate. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    
    var keyboardHeight : CGFloat = 30.0
    var messages : [Message] = [Message]()
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var BottomConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
       
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tabGesture)

        messageTableView.register(UINib(nibName: "MessageCell",bundle: nil ), forCellReuseIdentifier: "messageCell")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        configureTableView()
        retriveMessages()
        self.messageTableView.allowsSelection = false
        self.messageTableView.separatorStyle = .none
        self.sendButton.isEnabled = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        print(messages.count)
        print(messageTableView.numberOfRows(inSection: 0))
        //self.messageTableView.scrollToRow(at: IndexPath(row: messages.count-1, section: 0), at: .bottom, animated: false)
    }
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(messages[indexPath.row].sender == Auth.auth().currentUser?.email){
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
            cell.messageBody.text = messages[indexPath.row].messageBody
            cell.senderUsername.text = messages[indexPath.row].sender
            cell.avatarImageView.image = UIImage.init(named: "egg")
            cell.setToMyMessage(true)
            cell.layoutIfNeeded()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
            cell.messageBody.text = messages[indexPath.row].messageBody
            cell.senderUsername.text = messages[indexPath.row].sender
            cell.avatarImageView.image = UIImage.init(named: "egg")
            cell.setToMyMessage(false)
            cell.layoutIfNeeded()
            return  cell
        }
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView(){
        messageTableView.estimatedRowHeight = 150.0
        messageTableView.rowHeight = UITableViewAutomaticDimension
        print("sfsaff \(UITableViewAutomaticDimension)")
    }
    
    
    ///////////////////////////////////////////
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
        UIView.animate(withDuration: 0.5) {
            self.BottomConstraint.constant = self.keyboardHeight
            self.view.layoutIfNeeded()
        }
        
        // do whatever you want with this keyboard height
    }
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.BottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
   
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase MaxKak
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        //TODO: Send the message to Firebase and save it in our database
        messageTextfield.endEditing(true)
        sendButton.isEnabled = false
        messageTextfield.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        let messageDict = ["sender" : Auth.auth().currentUser?.email,"messageBody" : messageTextfield.text]
        messageDB.childByAutoId().setValue(messageDict){
            (err,ref) in
            if(err != nil){
               print(err!)
            }
            else{
                print("succesfully")
                self.messageTextfield.endEditing(false)
                self.sendButton.isEnabled = false
                self.messageTextfield.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
        
    }
    
    //TODO: Create the retrieveMessages method here:
    func retriveMessages(){
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded, with:{ (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let sender = snapshotValue["sender"]
            let message = snapshotValue["messageBody"]
            let mes = Message()
            mes.messageBody = message!
            mes.sender = sender!
            self.messages.append(mes)
            self.configureTableView()
            self.messageTableView.reloadData()
            self.messageTableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: false)
        })
    }
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do{
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }
        catch{
            print("sign out error")
        }
    }
    
    @IBAction func textFieldDidChanged(_ sender: Any) {
        self.sendButton.isEnabled = (messageTextfield.text == "") ? false : true
        
    }
    

}

