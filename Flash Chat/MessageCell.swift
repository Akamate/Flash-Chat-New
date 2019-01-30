//
//  OtherMessageCell.swift
//  Flash Chat
//
//  Created by Aukmate  Chayapiwat on 23/1/2562 BE.
//  Copyright © 2562 Akamate. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    //@IBOutlet var avatarImageView: UIImageView!
    
    @IBOutlet var messageBackground: UIView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var senderUsername: UILabel!
    @IBOutlet var stackView: UIStackView!
    var isMyMes : Bool = false
    @IBOutlet var profileImg: UILabel!
    @IBOutlet var messageView: UIView!
 
    override func awakeFromNib() {
        super.awakeFromNib()

        messageBackground.clipsToBounds = true
        messageBackground.layer.cornerRadius = 12.0
        profileImg.layer.masksToBounds = true
        profileImg.layer.cornerRadius = 25.0
    }
    override func prepareForReuse() {
        setToMyMessage()
    }
    func setToMyMessage(){
            messageBackground.backgroundColor = UIColor.init(red: 66/255, green: 134/255, blue: 244/255, alpha: 1.0)
            profileImg.backgroundColor = UIColor.black
            profileImg.font = UIFont(name: "AvenirNext-Regular", size: 20.0)
//        }
//        else {
//            self.isMyMes = isMyMes
//             messageBackground.backgroundColor = UIColor.init(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
//             profileImg.backgroundColor = UIColor.brown
//             profileImg.font = UIFont(name: "AvenirNext-Regular", size: 17.0)
//        }
    }
//    private func setConstraint(){
//        if(isMyMes){
//            messageBackground.leadingAnchor.constraint(lessThanOrEqualTo: messageView.leadingAnchor, constant: 10).isActive = false
//            messageBody.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 10).isActive = false
//            messageBackground.leadingAnchor.constraint(greaterThanOrEqualTo: messageView.leadingAnchor, constant: 10).isActive = true
//            messageBody.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -10).isActive = true
//        }
//        else {
//            messageBackground.leadingAnchor.constraint(greaterThanOrEqualTo: messageView.leadingAnchor, constant: 10).isActive = false
//            messageBody.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -10).isActive = false
//            messageBackground.trailingAnchor.constraint(lessThanOrEqualTo: messageView.trailingAnchor, constant: -10).isActive = true
//            messageBody.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 10).isActive = true
//        }
    //}

}
