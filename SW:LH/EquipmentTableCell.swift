//
//  EquipmentTableCell.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/6/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class EquipmentTableCell: UITableViewCell {
    @IBOutlet weak var equipmentImageView: UIImageView!
    @IBOutlet weak var equipmentNameLabel: UILabel!
    @IBOutlet weak var equipmentAttackLabel: UILabel!
    @IBOutlet weak var equipmentProtectionLabel: UILabel!
    @IBOutlet weak var equipmentCostLabel: UILabel!
    @IBOutlet weak var equipmentQuantityLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
