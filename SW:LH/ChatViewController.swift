//
//  ChatViewController.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/10/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    
    let webService = Webservice()
    let util = Util()
    let socket = Socket.getInstance()
    let user = User.sharedInstance
    let chatList = ChatList.sharedInstance
    let blockList = BlockList.sharedInstance
    let badWords = ["fuck", "ass", "bitch", "dam", "damn", "nigger", "nigga", "nigg3r", "cracker", "cracka", "spick", "shit", "hoe", "hoes", "whore", "whores", "slut", "sluts", "sloot", "sloots"]
    
    var tableData = [ChatDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.registerNib(UINib(nibName: "ChatTableCell", bundle: nil), forCellReuseIdentifier: "ChatTableCell")
        initChats()
    }
    
    override func viewDidAppear(animated: Bool) {
        socket.view = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onBackButton (sender : AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSendChatButton (sender : AnyObject) {
        var chatMessage = textField.text!
        
        if (chatMessage.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "") {
            //Filter bad words from chat message
            chatMessage = filterBadWords(chatMessage)
            
            let json = ["message" : chatMessage, "avatar" : user.avatar, "username" : user.username]
            socket.socket.emit("send_message", json)
            textField.text = ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = tableData[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatTableCell", forIndexPath: indexPath) as! ChatTableCell
        
        cell.avatarImageView.image = model.avatarImage
        cell.chatTextView.text = model.chatMessage
        cell.usernameLabel.text = model.username
        cell.blockUserButton.tag = indexPath.row
        cell.blockUserButton.addTarget(self, action: #selector(ChatViewController.blockUser(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func blockUser (sender : AnyObject) {
        if let button = sender as? UIButton {
            let model = tableData[button.tag]
            let alert = UIAlertController(title: "Block User", message: "Blocking this user will make their chats invisible to you. Are you sure you want to block this user?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (alertAction : UIAlertAction) in
                self.blockList.list.append(model.username)
                self.filterChat()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (alertAction : UIAlertAction) in
                return
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func filterChat () {
        for i in 0..<tableData.count {
            let currentChat = tableData[i]
            
            for blockedUser in self.blockList.list {
                if (currentChat.username == blockedUser) {
                    //Remove from table data and chat list
                    self.chatList.chats.removeAtIndex(i)
                    tableData.removeAtIndex(i)
                }
            }
        }
        
        myTableView.reloadData()
    }
    
    func initChats() {
        for chat in chatList.chats {
            if let chatModel = chat as? ChatDataModel {
                tableData.append(chatModel)
            }
        }
        
        myTableView.reloadData()
    }
    
    func filterBadWords(chatMessage : String) -> String {
        var message = chatMessage.lowercaseString
        
        for badWord in badWords {
            message = message.stringByReplacingOccurrencesOfString(badWord, withString: "")
        }
    
        return message
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
