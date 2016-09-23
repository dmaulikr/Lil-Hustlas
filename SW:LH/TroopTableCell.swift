//
//  TroopTableCell.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/19/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class TroopTableCell: UITableViewCell {
    @IBOutlet weak var troopImageView: UIImageView!
    @IBOutlet weak var troopNameLabel: UILabel!
    @IBOutlet weak var troopAttackLabel: UILabel!
    @IBOutlet weak var troopHealthLabel: UILabel!
    @IBOutlet weak var buyTroopButton: UIButton!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
