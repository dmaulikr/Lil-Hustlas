//
//  FightViewController.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/31/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class FightViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var assistantTextView: UITextView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var chatTextView: UITextView!
    
    let user = User.sharedInstance
    let webService = Webservice()
    let util = Util()
    let socket = Socket.getInstance()
    let chatList = ChatList.sharedInstance
    
    var tableData = [AnyObject]()
    var selectedFightResult : NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.registerNib(UINib(nibName: "FightTableCell", bundle: nil), forCellReuseIdentifier: "FightTableCell")
    }
    
    override func viewDidAppear(animated: Bool) {
        socket.view = self
        self.updateUserDataFromSingleton()
        self.setChat()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FightToFightResult" {
            let viewController = segue.destinationViewController as! FightResultViewController
            viewController.fightResult = selectedFightResult
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFightButton (sender : UIButton) {
        initFightList()
    }
    
    @IBAction func onBountiesButton (sender : AnyObject) {
        
    }
    
    // MARK: - UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let model = tableData[indexPath.row] as? FightDataModel {
            let cell = tableView.dequeueReusableCellWithIdentifier("FightTableCell", forIndexPath: indexPath) as! FightTableCell
            
            cell.usernameLabel.text = model.username
            cell.hoodLevelLabel.text = model.hoodLevel
            cell.powerLabel.text = model.power
            cell.fightButton.tag = indexPath.row
            cell.fightButton.addTarget(self, action: #selector(FightViewController.onFightUserButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func onFightUserButton (sender : UIButton) {
        let model = tableData[sender.tag] as! FightDataModel
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        loadingView.show()
        
        webService.attack_user(user.accountId, deviceId: deviceId, userId: model.userId, onComplete: { (json) in
            loadingView.terminate()
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let user = json["user"] as? NSDictionary {
                        self.user.updateSingleton(user)
                    }
                    if let fightResult = json["fightResult"] as? NSDictionary {
                        if let otherUser = json["otherUser"] as? NSDictionary {
                            self.updateFightList(otherUser)
                        }
                        self.selectedFightResult = fightResult
                        self.performSegueWithIdentifier("FightToFightResult", sender: self)
                    }
                    if let user = json["user"] as? NSDictionary {
                        self.user.updateSingleton(user)
                        self.updateUserDataFromSingleton()
                    }
                    
                }
                else {
                    if let errorMessage = json["errorMessage"] as? String {
                        self.util.getAlertForError(self, message: errorMessage)
                    }
                    else {
                        self.util.getAlertForError(self)
                    }
                }
            }
            }) { 
                self.util.getAlertForError(self)
        }
        
    }
    
    func initFightList() {
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        loadingView.show()
        
        webService.getFightList(user.accountId, deviceId: deviceId, onComplete: { (json) in
            loadingView.terminate()
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let fightList = json["users"] as? NSArray {
                        self.populateFightListData(fightList)
                    }
                }
                else {
                    if let errorMessage = json["errorMessage"] as? String {
                        self.util.getAlertForError(self, message: errorMessage)
                    }
                    else {
                        self.util.getAlertForError(self)
                    }
                }
            }
            }) { 
                self.util.getAlertForError(self)
        }
    }
    
    func populateFightListData(fightList : NSArray) {
        tableData = [AnyObject]()
        
        for user in fightList {
            let model = FightDataModel()
            model.username = ""
            if let userId = user["user_id"] as? String {
                model.userId = userId
            }
            if let hoodLevel = user["hood"] as? String {
                model.hoodLevel = "Hood: " + hoodLevel
            }
            if let power = user["power"] as? String {
                model.power = "Power: " + power
            }
            if let username = user["username"] as? String {
                model.username = username
            }
            
            tableData.append(model)
        }
        
        myTableView.reloadData()
    }
    
    func updateFightList (user : NSDictionary) {
        for i in 0..<tableData.count {
            if let model = tableData[i] as? FightDataModel {
                if let userId = user["user_id"] as? String {
                    if model.userId == userId {
                        if let power = user["power"] as? String {
                            model.power = "Power: " + power
                            break
                        }
                    }
                }
            }
        }

        myTableView.reloadData()
    }
    
    func updateUserDataFromSingleton() {
        moneyLabel.text = "$ " + user.money
        levelLabel.text = "Lvl: " + user.level
        powerLabel.text = "Power: " + user.power
    }
    
    func setChat() {
        var chatText = "";
        
        for currentChat in chatList.chats {
            if let model = currentChat as? ChatDataModel {
                chatText += model.username + " : " + model.chatMessage + "\n";
            }
        }
        
        self.chatTextView.text = chatText;
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
