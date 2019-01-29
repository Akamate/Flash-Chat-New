//
//  OtherMessageCell.swift
//  Flash Chat
//
//  Created by Aukmate  Chayapiwat on 23/1/2562 BE.
//  Copyright © 2562 London App Brewery. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBackground: UIView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    @IBOutlet var stackView: UIStackView!
    var isMyMes : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     //   avatarImageView.layer.cornerRadius = 25.0
        messageBackground.layer.cornerRadius = 12.0
        
    }
    override func prepareForReuse() {
        setToMyMessage(isMyMes)
    }
    func setToMyMessage(_ isMyMes : Bool){
        if(isMyMes){
            self.isMyMes = isMyMes
            messageBackground.backgroundColor = UIColor.init(red: 66/255, green: 134/255, blue: 244/255, alpha: 1.0)
            let elements = stackView.arrangedSubviews
            stackView.removeArrangedSubview(elements[0])
            stackView.addArrangedSubview(elements[0])
        }
        else {
            self.isMyMes = isMyMes
             messageBackground.backgroundColor = UIColor.init(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
        }
    }
}
