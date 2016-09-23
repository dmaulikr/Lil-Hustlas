//
//  AssetDataModel.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/27/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class AssetDataModel: NSObject {
    var title = ""
    var identifier = ""
    var level = ""
    var cost = ""
    var assetDescription = ""
    
    init(title : String, identifier : String, level : String, cost : String, assetDescription : String) {
        self.title = title
        self.identifier = identifier
        self.level = "Lvl: " + level
        self.cost = "$" + cost
        self.assetDescription = assetDescription
    }

}
