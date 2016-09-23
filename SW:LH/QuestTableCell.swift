//
//  QuestTableCell.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/15/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class QuestTableCell: UITableViewCell {
    @IBOutlet weak var questTitleLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var doMissionButton: UIButton!
    @IBOutlet weak var masteryLabel: UILabel!
    @IBOutlet weak var masteryImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
