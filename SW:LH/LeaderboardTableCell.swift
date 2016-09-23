//
//  LeaderboardTableCell.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/9/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class LeaderboardTableCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var fightsLabel: UILabel!
    @IBOutlet weak var killsLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var missionsLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
