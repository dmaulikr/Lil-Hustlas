//
//  Notification.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/18/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class Notification: NSObject {
    var notifications = [NSObject]();
    class var sharedInstance: Notification {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Notification? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Notification()
        }
        return Static.instance!
    }
}
