//
//  MyMessageCell.swift
//  Flash Chat
//
//  Created by Aukmate  Chayapiwat on 24/1/2562 BE.
//  Copyright © 2562 London App Brewery. All rights reserved.
//

import UIKit

class MyMessageCell: UITableViewCell {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBackground: UIView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
