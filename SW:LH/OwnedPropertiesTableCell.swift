//
//  OwnedPropertiesTableCell.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 9/3/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class OwnedPropertiesTableCell: UITableViewCell {
    @IBOutlet weak var propertyImageView: UIImageView!
    @IBOutlet weak var propertyNameLabel: UILabel!
    @IBOutlet weak var junkiesLabel: UILabel!
    @IBOutlet weak var ballersLabel: UILabel!
    @IBOutlet weak var cripsLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var addJunkiesButton: UIButton!
    @IBOutlet weak var addBallersButton: UIButton!
    @IBOutlet weak var addCripsButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
