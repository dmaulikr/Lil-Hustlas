//
//  User.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/15/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class User: NSObject {
    var accountId = ""
    var username = ""
    var avatar = ""
    var money = ""
    var users = ""
    var hood = ""
    var power = ""
    var marchSize = ""
    var junkieTactics = ""
    var ballerTactics = ""
    var cripTactics = ""
    var level = ""
    var junkies = ""
    var ballers = ""
    var crips = ""
    
    func updateSingleton(user : NSDictionary) {
        if let accountId = user["accountId"] as? String {
            self.accountId = accountId
        }
        if let username = user["username"] as? String {
            self.username = username
        }
        if let avatar = user["avatar"] as? String {
            self.avatar = avatar
        }
        if let power = user["power"] as? String {
            self.power = power
        }
        if let level = user["level"] as? String {
            self.level = level
        }
        if let money = user["money"] as? String {
            self.money = money
        }
        if let users = user["users"] as? String {
            self.users = users
        }
        if let hood = user["hood"] as? String {
            self.hood = hood
        }
        if let marchSize = user["march_size"] as? String {
            self.marchSize = marchSize
        }
        if let junkieTactics = user["junkie_tactics"] as? String {
            self.junkieTactics = junkieTactics
        }
        if let ballerTactics = user["baller_tactics"] as? String {
            self.ballerTactics = ballerTactics
        }
        if let cripTactics = user["crip_tactics"] as? String {
            self.cripTactics = cripTactics
        }
        if let junkies = user["junkies"] as? String {
            self.junkies = junkies
        }
        if let ballers = user["ballers"] as? String {
            self.ballers = ballers
        }
        if let crips = user["crips"] as? String {
            self.crips = crips
        }
    }
    
    class var sharedInstance: User {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: User? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = User()
        }
        return Static.instance!
    }
}
