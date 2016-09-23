//
//  NotificationTableCell.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/17/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class NotificationTableCell: UITableViewCell {
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
