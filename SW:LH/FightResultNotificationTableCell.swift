//
//  FightResultNotificationTableCell.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/15/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class FightResultNotificationTableCell: UITableViewCell {
    @IBOutlet weak var notificationDescription: UITextView!
    @IBOutlet weak var notificationDate: UILabel!
    @IBOutlet weak var retaliateButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
