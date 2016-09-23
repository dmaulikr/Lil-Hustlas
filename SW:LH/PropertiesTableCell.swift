//
//  PropertiesTableCell.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 9/2/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class PropertiesTableCell: UITableViewCell {
    @IBOutlet weak var propertyImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var attackButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
