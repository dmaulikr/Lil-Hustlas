//
//  AssetTableCell.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/27/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class AssetTableCell: UITableViewCell {
    @IBOutlet weak var assetTitleLabel: UILabel!
    @IBOutlet weak var assetLevelLabel: UILabel!
    @IBOutlet weak var assetCostLabel: UILabel!
    @IBOutlet weak var assetDescriptionLabel: UITextView!
    @IBOutlet weak var upgradeAssetButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
