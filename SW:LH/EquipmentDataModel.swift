//
//  EquipmentDataModel.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/6/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class EquipmentDataModel: NSObject {
    var equipmentImage = UIImage()
    var equipmentName = ""
    var equipmentAttack = ""
    var equipmentProtection = ""
    var equipmentIdentifier = ""
    var equipmentCost = ""
    var equipmentQuantity = "0"
    
    init(image : UIImage, name : String, attack : String, protection : String, cost : String, identifier : String) {
        equipmentImage = image
        equipmentName = name
        equipmentAttack = attack
        equipmentProtection = protection
        equipmentIdentifier = identifier
        equipmentCost = cost
    }
}
