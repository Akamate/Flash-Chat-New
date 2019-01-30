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
    
    
    var keyboardHeight : CGFloat = 0.0
    var messages : [Message] = [Message]()
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var BottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        configureTableView()
        retriveMessages()
        
    }
    private func setDelegate(){
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
    }
    
    private func configureTableView(){
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tabGesture)
        
        messageTableView.register(UINib(nibName: "MessageCell",bundle: nil ), forCellReuseIdentifier: "messageCell")
        messageTableView.register(UINib(nibName: "OtherMessageCell",bundle: nil ), forCellReuseIdentifier: "otherMessageCell")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        messageTableView.estimatedRowHeight = 150.0
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.allowsSelection = false
        messageTableView.separatorStyle = .none
        sendButton.isEnabled = false
        
    }
    
    //TableView Method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(messages[indexPath.row].sender == Auth.auth().currentUser?.email){
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
            let message = messages[indexPath.row].messageBody
            cell.messageBody.text = message
            cell.senderUsername.text = messages[indexPath.row].sender
            let sender = messages[indexPath.row].sender
            cell.profileImg.text = String(sender[sender.startIndex]).uppercased()
            cell.setToMyMessage()
            cell.messageBody.textAlignment = .right
            cell.senderUsername.textAlignment = .right
            print(cell.messageBody.widthAnchor)
            print(cell.messageBody.heightAnchor)
            cell.layoutIfNeeded()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherMessageCell", for: indexPath) as! OtherMessageCell
            cell.messageBody.text = messages[indexPath.row].messageBody
            cell.senderUsername.text = messages[indexPath.row].sender
            let sender = messages[indexPath.row].sender
            cell.profileImg.text = String(sender[sender.startIndex]).uppercased()
            cell.setToMyOtherMessage()
            cell.messageBody.textAlignment = .left
            cell.senderUsername.textAlignment = .left
            cell.layoutIfNeeded()
            return  cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    

    //Swipe Cell to Delete
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            Database.database().reference().child("Messages").child(self.messages[indexPath.row].key).removeValue()
            print("index path of delete: \(indexPath)")
            self.messages.remove(at: indexPath.row)
            self.messageTableView.reloadData()
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
    ///////////////////////////////////////////
    //Get Keyboard Height
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
        UIView.animate(withDuration: 0.5) {
            self.BottomConstraint.constant = self.keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
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
    
    // LoadMessage
    func retriveMessages(){
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded, with:{ (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let sender = snapshotValue["sender"]
            let message = snapshotValue["messageBody"]
            let mes = Message()
            mes.messageBody = message!
            mes.sender = sender!
            mes.key = snapshot.key
            self.messages.append(mes)
            self.configureTableView()
            self.messageTableView.reloadData()
            
            if(self.messages.count > 0){
                self.messageTableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: false)
            }
        })
    }
    

    
    //LOGOUT
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        do{
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }
        catch{
            print("sign out error")
        }
    }
    
    //endEditing Message
    
}

extension ChatViewController : UITextViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.BottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    @IBAction private func textFieldDidChanged(_ sender: Any) {
        self.sendButton.isEnabled = (messageTextfield.text == "") ? false : true
        
    }
}
