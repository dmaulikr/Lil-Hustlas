//
//  ChatList.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/10/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class ChatList: NSObject {
    var chats = [NSObject]();
    class var sharedInstance: ChatList {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ChatList? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ChatList()
        }
        return Static.instance!
    }
}
