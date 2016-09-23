//
//  QuestViewController.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/15/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit
import GoogleMobileAds

class QuestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADInterstitialDelegate {
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var enduranceLabel: UILabel!
    @IBOutlet weak var hustleLabel: UILabel!
    @IBOutlet weak var energyImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var statPointsLabel: UILabel!
    @IBOutlet weak var auraImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var chatTextView: UITextView!
    
    let webService = Webservice()
    let util = Util()
    let user = User.sharedInstance
    let socket = Socket.getInstance()
    let chatList = ChatList.sharedInstance
    let notification = Notification.sharedInstance
    var interstitial: GADInterstitial!
    var viewControllerLoaded = false
    
    var tableData = [QuestDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.registerNib(UINib(nibName: "QuestTableCell", bundle: nil), forCellReuseIdentifier: "QuestTableCell")
        //initQuests()
        createAndLoadInterstitial()
        initCharacter()
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.notification.notifications.count <= 0 {
            self.tabBarController?.tabBar.items![4].badgeValue = nil
        }
        else {
            self.tabBarController?.tabBar.items![4].badgeValue = String(self.notification.notifications.count)
        }
        
        socket.view = self
        initQuests()
        self.setChat()
        
        //Dont update user data from singleton if this is the first time this viewcontroller was loaded
        if !viewControllerLoaded {
            viewControllerLoaded = true
        }
        else {
            updateUserDataFromSingleton()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRestButton(sender : AnyObject) {
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        loadingView.show()
        
        webService.restUser(user.accountId, deviceId: deviceId, onComplete: { (json) in
            loadingView.terminate()
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if self.interstitial.isReady {
                        self.interstitial.presentFromRootViewController(self)
                        self.createAndLoadInterstitial()
                    } else {
                        print("Ad wasn't ready")
                    }
                    
                    if let user = json["user"] as? NSDictionary {
                        self.user.updateSingleton(user)
                        self.populateUserData(user)
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
    
    @IBAction func onUpgradeStatButton (sender : AnyObject) {
        var statIdentifier = ""
        if sender.tag == 1 {
            statIdentifier = "attack"
        }
        else if sender.tag == 2 {
            statIdentifier = "endurance"
        }
        else {
            statIdentifier = "hustle"
        }
        
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        loadingView.show()
        
        webService.upgradeStat(user.accountId, deviceId: deviceId, statIdentifier: statIdentifier, onComplete: { (json) in
            loadingView.terminate()
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let user = json["user"] as? NSDictionary {
                        self.user.updateSingleton(user)
                        self.populateUserData(user)
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 115.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestTableCell", forIndexPath: indexPath) as! QuestTableCell
        let model = tableData[indexPath.row]
        
        cell.questTitleLabel.text = model.questTitle
        cell.energyLabel.text = model.questEnergyCost
        cell.moneyLabel.text = model.questMoneyReward
        cell.masteryLabel.text = model.masteryLevel
        cell.masteryImageView.image = util.getAuraBar(model.masteryPercent)
        cell.expLabel.text = model.questExpReward
        cell.doMissionButton.tag = indexPath.row
        cell.doMissionButton.addTarget(self, action: #selector(QuestViewController.doMission(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func initQuests() {
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        loadingView.show()
        
        webService.getMissions(user.accountId, deviceId: deviceId, onComplete: { (json) in
            loadingView.terminate()
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let missions = json["missions"] as? NSArray {
                        if let activeMissions = json["active_missions"] as? NSArray {
                            self.populateTableData(missions, activeMissions: activeMissions)
                        }
                    }
                }
                else {
                    self.util.getAlertForError(self)
                }
            }
            }) { 
                self.util.getAlertForError(self)
        }
    }
    
    func initCharacter() {
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        loadingView.show()
        
        webService.getUser(user.accountId, deviceId: deviceId, onComplete: { (json) in
            loadingView.terminate()
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let user = json["user"] as? NSDictionary {
                        self.user.updateSingleton(user)
                        self.populateUserData(user)
                    }
                    else {
                        if let errorMessage = json["errorMessage"] as? String {
                            self.util.getAlertForError(self, message: errorMessage)
                        }
                    }
                }
                else {
                    self.util.getAlertForError(self)
                }
            }
            }) { 
                self.util.getAlertForError(self)
        }
        
    }
    
    func populateTableData (missions : NSArray, activeMissions : NSArray) {
        tableData = [QuestDataModel]()
        for mission in missions {
            let model = QuestDataModel()
            if let questTitle = mission["mission_name"] as? String {
                model.questTitle = questTitle
            }
            if let questEnergyCost = mission["mission_energy_cost"] as? String {
                model.questEnergyCost = questEnergyCost
            }
            if let questExpReward = mission["mission_exp_reward"] as? String {
                model.questExpReward = questExpReward
            }
            if let questEnergyCost = mission["mission_energy_cost"] as? String {
                model.questEnergyCost = questEnergyCost
            }
            if let questMoneyReward = mission["mission_money_reward"] as? String {
                if let questMoneyRewardMax = mission["mission_money_reward_max"] as? String {
                    //Append dollar sign next to money reward
                    model.questMoneyReward = "$ " + questMoneyReward + "-" + questMoneyRewardMax
                }
            }
            if let questExpReward = mission["mission_exp_reward"] as? String {
                model.questExpReward = "Xp: " + questExpReward
            }
            if let questId = mission["mission_id"] as? String {
                model.questId = questId
            }
            
            for activeMission in activeMissions {
                if let activeMissionMissionId = activeMission["mission_id"] as? String {
                    if let missionId = mission["mission_id"] as? String {
                        if missionId == activeMissionMissionId {
                            if let masteryLevel = activeMission["active_mission_mastery_level"] as? String {
                                model.masteryLevel = masteryLevel
                                
                                if (Int(masteryLevel)! >= 250) {
                                    model.masteryLevel = "MAX"
                                }
                                
                                if let missionMasteryCount = activeMission["active_mission_mastery_count"] as? String {
                                    if let missionMasteryCompleteCount = activeMission["active_mission_mastery_complete_count"] as? String {
                                        var percent = Float(missionMasteryCount)! / Float(missionMasteryCompleteCount)!
                                        percent *= 100
                                        model.masteryPercent = Int(percent)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            tableData.append(model)
        }
        
        myTableView.reloadData()
    }
    
    func populateUserData (user : NSDictionary) {
        if let avatar = user["avatar"] as? String {
            if let avatarImage = UIImage(named: avatar) {
                avatarImageView.image = avatarImage
            }
        }
        if let power = user["power"] as? String {
            powerLabel.text = "Power: " + power
        }
        if let attack = user["attack"] as? String {
            attackLabel.text = attack
        }
        if let endurance = user["endurance"] as? String {
            enduranceLabel.text = endurance
        }
        if let hustle = user["hustle"] as? String {
            hustleLabel.text = hustle
        }
        if let money = user["money"] as? String {
            moneyLabel.text = "$ " + money
        }
        if let level = user["level"] as? String {
            levelLabel.text = "Lvl: " + level
        }
        if let statPoints = user["stat_points"] as? String {
            statPointsLabel.text = "Stat Points: " + statPoints
        }
        if let energy = user["energy"] as? String {
            if let maxEnergy = user["max_energy"] as? String {
                var percent = Float(energy)! / Float(maxEnergy)!
                percent *= 100
                let energyPercent = Int(percent)
                energyImageView.image = util.getEnergyBar(energyPercent)
            }
        }
        if let exp = user["exp"] as? String {
            if let tnl = user["tnl"] as? String {
                var percent = Float(exp)! / Float(tnl)!
                percent *= 100
                let tnlPercent = Int(percent)
                auraImageView.image = util.getAuraBar(percent)
            }
        }
    }
    
    func doMission(sender : UIButton) {
        let model = tableData[sender.tag]
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        loadingView.show()
        
        print(user.accountId)
        
        webService.doMission(user.accountId, deviceId: deviceId, missionId: model.questId, onComplete: { (json) in
            loadingView.terminate()
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let user = json["user"] as? NSDictionary {
                        self.user.updateSingleton(user)
                        self.populateUserData(user)
                    }
                    if let levelUp = json["levelUp"] as? Bool {
                        if levelUp == true {
                            self.util.getAlertForForLevelUp(self)
                        }
                    }
                    if let masteryUp = json["masteryUp"] as? Bool {
                        if masteryUp == true {
                            self.util.getAlertForForMasteryUp(self)
                        }
                    }
                    
                    self.initQuests()
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
    
    func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7120523287584402/5479586971")
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID, "48cbe83e1127ed28bda257d3529a0556591a2384" ]
        interstitial.loadRequest(request)
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
