//
//  FightTableCell.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/31/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class FightTableCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var hoodLevelLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var fightButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
