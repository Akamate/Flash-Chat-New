//
//  OtherMessageCell.swift
//  Flash Chat
//
//  Created by Aukmate  Chayapiwat on 30/1/2562 BE.
//  Copyright © 2562 London App Brewery. All rights reserved.
//

import UIKit

class OtherMessageCell: UITableViewCell {
   
    @IBOutlet var senderUsername: UILabel!
    @IBOutlet var messageBackground: UIView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var profileImg: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageBackground.clipsToBounds = true
        messageBackground.layer.cornerRadius = 12.0
        profileImg.layer.masksToBounds = true
        profileImg.layer.cornerRadius = 25.0
    }

    override func prepareForReuse() {
        setToMyOtherMessage()
    }
    func setToMyOtherMessage(){
        messageBackground.backgroundColor = UIColor.init(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
        profileImg.backgroundColor = UIColor.brown
        profileImg.font = UIFont(name: "AvenirNext-Regular", size: 17.0)
     
    }
    
}
