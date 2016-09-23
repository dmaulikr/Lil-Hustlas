//
//  ChatTableCell.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/10/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class ChatTableCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var blockUserButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
