//
//  BlockList.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/26/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class BlockList: NSObject {
    var list = [String]();
    class var sharedInstance: BlockList {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: BlockList? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = BlockList()
        }
        return Static.instance!
    }
}
