//
//  Socket.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/10/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class Socket: NSObject {
    static let socketInstance = Socket();
    let socket = SocketIOClient (socketURL: NSURL(string: "https://shielded-scrubland-54457.herokuapp.com")!);
    //let socket = SocketIOClient (socketURL: NSURL(string: "http://localhost:8080")!);
    let util = Util();
    let user = User.sharedInstance;
    let notification = Notification.sharedInstance
    let chatList = ChatList.sharedInstance
    let blockList = BlockList.sharedInstance
    var view : UIViewController! = nil
    
    
    static func getInstance() ->Socket {
        return socketInstance;
    }
    
    func initHandlers() {
        socket.on("alert_user") { (data : [AnyObject], socket : SocketAckEmitter) in
            if (self.view != nil) {
                self.notification.notifications.append("")
                self.view.tabBarController?.tabBar.items![4].badgeValue = String(self.notification.notifications.count)
            }
        }
        
        socket.on("connection") { (data : [AnyObject], emitter : SocketAckEmitter) in
            let json = ["userId" : self.user.accountId]
            self.socket.emit("set_user_socket", json)
        }
        
        socket.on("send_message") { (data : [AnyObject], socket : SocketAckEmitter) in
            if let _ = self.view as? ChatViewController {
                let viewController = self.view as! ChatViewController
                let json = data[0] as! NSDictionary
                let model = ChatDataModel()
                model.chatMessage = json["message"] as! String
                
                if let avatar = json["avatar"] as? String {
                    model.avatarImage = UIImage(named: avatar)!
                }
                if let username = json["username"] as? String {
                    model.username = username
                }
                
                //Check to see if the sender of this message is blocked by this user
                var isBlocked = false
                for blockedUser in self.blockList.list {
                    if blockedUser == model.username {
                        isBlocked = true
                    }
                }
                
                if isBlocked {
                    return
                }
                
                viewController.tableData.insert(model, atIndex: 0)
                viewController.myTableView.reloadData()
                self.chatList.chats.insert(model, atIndex: 0)
            }
            else if let _ = self.view as? QuestViewController {
                let viewController = self.view as! QuestViewController
                let json = data[0] as! NSDictionary
                let model = ChatDataModel()
                model.chatMessage = json["message"] as! String
                if let avatar = json["avatar"] as? String {
                    model.avatarImage = UIImage(named: avatar)!
                }
                if let username = json["username"] as? String {
                    model.username = username
                }
                
                //Check to see if the sender of this message is blocked by this user
                //If the sender is blocked, return before appending the message to list
                var isBlocked = false
                for blockedUser in self.blockList.list {
                    if blockedUser == model.username {
                        isBlocked = true
                    }
                }
                
                if isBlocked {
                    return
                }
                
                self.chatList.chats.insert(model, atIndex: 0)
                viewController.setChat();
            }
            else if let _ = self.view as? HoodViewController {
                let viewController = self.view as! HoodViewController
                let json = data[0] as! NSDictionary
                let model = ChatDataModel()
                model.chatMessage = json["message"] as! String
                if let avatar = json["avatar"] as? String {
                    model.avatarImage = UIImage(named: avatar)!
                }
                if let username = json["username"] as? String {
                    model.username = username
                }
                
                //Check to see if the sender of this message is blocked by this user
                var isBlocked = false
                for blockedUser in self.blockList.list {
                    if blockedUser == model.username {
                        isBlocked = true
                    }
                }
                
                if isBlocked {
                    return
                }
                
                self.chatList.chats.insert(model, atIndex: 0)
                viewController.setChat()
            }
            else if let _ = self.view as? FightViewController {
                let viewController = self.view as! FightViewController
                let json = data[0] as! NSDictionary
                let model = ChatDataModel()
                model.chatMessage = json["message"] as! String
                if let avatar = json["avatar"] as? String {
                    model.avatarImage = UIImage(named: avatar)!
                }
                if let username = json["username"] as? String {
                    model.username = username
                }
                
                //Check to see if the sender of this message is blocked by this user
                var isBlocked = false
                for blockedUser in self.blockList.list {
                    if blockedUser == model.username {
                        isBlocked = true
                    }
                }
                
                if isBlocked {
                    return
                }
                
                self.chatList.chats.insert(model, atIndex: 0)
                viewController.setChat()
            }
        }
    }
}
