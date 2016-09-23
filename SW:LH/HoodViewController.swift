//
//  HoodViewController.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/19/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class HoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var assistantTextView: UITextView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var chatTextView: UITextView!
    
    let webService = Webservice()
    let util = Util()
    let user = User.sharedInstance
    let socket = Socket.getInstance()
    let chatList = ChatList.sharedInstance
    var assets = [AssetDataModel]()
    var equipment = [EquipmentDataModel]()
    var activeEquipment = [NSDictionary]()
    var currentTab : Tab!
    
    var hoodTableData = [AnyObject]()
    var assetTableData = [AssetDataModel]()
    
    enum Tab : Int {
        case troop = 0
        case equipment = 1
        case asset = 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.registerNib(UINib(nibName: "TroopTableCell", bundle: nil), forCellReuseIdentifier: "TroopTableCell")
        myTableView.registerNib(UINib(nibName: "TroopLockedTableCell", bundle: nil), forCellReuseIdentifier: "TroopLockedTableCell")
        myTableView.registerNib(UINib(nibName: "AssetTableCell", bundle: nil), forCellReuseIdentifier: "AssetTableCell")
        myTableView.registerNib(UINib(nibName: "EquipmentTableCell", bundle: nil), forCellReuseIdentifier: "EquipmentTableCell")
        
        getUser()
    }
    
    override func viewDidAppear(animated: Bool) {
        socket.view = self
        self.getActiveEquipment()
        self.updateUserDataFromSingleton()
        self.setChat()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSegment(sender : AnyObject) {
        if let segment = sender as? UISegmentedControl {
            if segment.selectedSegmentIndex == 0 {
                currentTab = Tab.troop
                hoodTableData = [AnyObject]()
                populateTroopTableData()
            }
            else if segment.selectedSegmentIndex == 1 {
                currentTab = Tab.equipment
                hoodTableData = [AnyObject]()
                populateEquipmentData()
            }
            else if segment.selectedSegmentIndex == 2 {
                currentTab = Tab.asset
                hoodTableData = [AnyObject]()
                populateAssetTableData()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hoodTableData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let model = hoodTableData[indexPath.row] as? TroopDataModel {
            let cell = tableView.dequeueReusableCellWithIdentifier("TroopTableCell", forIndexPath: indexPath) as! TroopTableCell
            
            cell.troopImageView.image = model.troopImage
            cell.troopNameLabel.text = model.troopName
            cell.troopAttackLabel.text = model.troopAttack
            cell.troopHealthLabel.text = model.troopHealth
            cell.costLabel.text = model.troopCost
            cell.quantityLabel.text = model.troopQuantity
            cell.buyTroopButton.tag = indexPath.row
            cell.buyTroopButton.addTarget(self, action: #selector(HoodViewController.onBuyTroopButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
        }
        else if let model = hoodTableData[indexPath.row] as? TroopLockedDataModel {
            let cell = tableView.dequeueReusableCellWithIdentifier("TroopLockedTableCell", forIndexPath: indexPath) as! TroopLockedTableCell
            
            cell.troopLockedTitle.text = model.troopLockedTitle
            
            return cell
        }
        else if let model = hoodTableData[indexPath.row] as? AssetDataModel {
            let cell = tableView.dequeueReusableCellWithIdentifier("AssetTableCell", forIndexPath: indexPath) as! AssetTableCell
            
            cell.assetTitleLabel.text = model.title
            cell.assetCostLabel.text = model.cost
            cell.assetLevelLabel.text = model.level
            cell.assetDescriptionLabel.text = model.assetDescription
            cell.upgradeAssetButton.tag = indexPath.row
            cell.upgradeAssetButton.addTarget(self, action: #selector(HoodViewController.onUpgradeAssetButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
        }
        else if let model = hoodTableData[indexPath.row] as? EquipmentDataModel {
            let cell = tableView.dequeueReusableCellWithIdentifier("EquipmentTableCell", forIndexPath: indexPath) as! EquipmentTableCell
            
            cell.equipmentImageView.image = model.equipmentImage
            cell.equipmentNameLabel.text = model.equipmentName
            cell.equipmentAttackLabel.text = "Attack: " + model.equipmentAttack
            cell.equipmentProtectionLabel.text = "Protection: " + model.equipmentProtection
            cell.equipmentCostLabel.text = "Cost: $" + model.equipmentCost
            cell.equipmentQuantityLabel.text = "Quantity: " + model.equipmentQuantity
            cell.buyButton.tag = indexPath.row
            cell.buyButton.addTarget(self, action: #selector(HoodViewController.onBuyEquipmentButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func onBuyEquipmentButton (sender : UIButton) {
        let model = hoodTableData[sender.tag] as! EquipmentDataModel
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        
        let alert = UIAlertController(title: "Quantity", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (textField : UITextField) in
            textField.placeholder = "How Many?"
            textField.keyboardType = UIKeyboardType.NumberPad;
        }
        alert.addAction(UIAlertAction(title: "Hire", style: UIAlertActionStyle.Default, handler: { (alertAction : UIAlertAction) in
            let textField = alert.textFields![0];
            if let quantity = Int(textField.text!) {
                loadingView.show()
                
                self.webService.buyEquipment(self.user.accountId, deviceId: deviceId, equipmentIdentifier: model.equipmentIdentifier, quantity: String(quantity), onComplete: { (json) in
                    loadingView.terminate()
                    
                    if let status = json["status"] as? NSNumber {
                        if status == 200 {
                            if let user = json["user"] as? NSDictionary {
                                self.user.updateSingleton(user)
                                self.populateUserData(user)
                            }
                            
                            self.getActiveEquipment()
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
                    }, onError: {
                        self.util.getAlertForError(self)
                })
            }
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func onBuyTroopButton (sender : UIButton) {
        let model = hoodTableData[sender.tag] as! TroopDataModel
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        
        let alert = UIAlertController(title: "Quantity", message: "", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addTextFieldWithConfigurationHandler { (textField : UITextField) in
            textField.placeholder = "How Many?";
            textField.keyboardType = UIKeyboardType.NumberPad;
        }
        alert.addAction(UIAlertAction(title: "Buy", style: UIAlertActionStyle.Default, handler: { (alertAction : UIAlertAction) in
            let textField = alert.textFields![0];
            if let quantity = Int(textField.text!) {
                loadingView.show()
                
                self.webService.buyTroops(self.user.accountId, deviceId: deviceId, quantity: String(quantity), troopIdentifier: model.troopIdentifier, onComplete: { (json) in
                    loadingView.terminate()
                    
                    if let status = json["status"] as? NSNumber {
                        if status == 200 {
                            if let user = json["user"] as? NSDictionary {
                                self.user.updateSingleton(user)
                                self.populateUserData(user)
                                self.populateTroopTableData()
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
                    }, onError: {
                        self.util.getAlertForError(self)
                })
            }
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func onUpgradeAssetButton (sender : UIButton) {
        if let model = hoodTableData[sender.tag] as? AssetDataModel {
            let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
            let loadingView = LoadingView(message: "Loading...", parentView: self.view)
            loadingView.show()
            
            print(model.identifier)
            
            webService.upgradeAsset(user.accountId, deviceId: deviceId, assetIdentifier: model.identifier, onComplete: { (json) in
                loadingView.terminate()
                
                if let status = json["status"] as? NSNumber {
                    if status == 200 {
                        if let user = json["user"] as? NSDictionary {
                            self.user.updateSingleton(user)
                            self.populateUserData(user)
                            self.populateAssetTableData()
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
                }, onError: {
                    self.util.getAlertForError(self)
            })
        }
    }
    
    func getUser() {
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
    
    func populateUserData (user : NSDictionary) {
        if let money = user["money"] as? String {
            moneyLabel.text = "$ " + money
        }
        if let level = user["level"] as? String {
            levelLabel.text = "Lvl: " + level
        }
    }
    
    func populateTroopTableData () {
        hoodTableData = [AnyObject]()
        
        let model1 = TroopDataModel()
        model1.troopName = "Junkie"
        model1.troopHealth = "Health: 100"
        model1.troopAttack = "Attack: 5"
        model1.troopCost = "Cost: $100"
        model1.troopImage = UIImage(named: "junkie")!
        model1.troopQuantity = "Quantity: " + user.junkies
        model1.troopIdentifier = "junkies"
        
        hoodTableData.append(model1)
        
        if (Int(user.hood) >= 10) {
            let model2 = TroopDataModel()
            model2.troopName = "Baller"
            model2.troopHealth = "Health: 500"
            model2.troopAttack = "Attack: 1"
            model2.troopCost = "Cost: $2500"
            model2.troopImage = UIImage(named: "baller")!
            model2.troopQuantity = "Quantity: " + user.ballers
            model2.troopIdentifier = "ballers"
            
            hoodTableData.append(model2)
        }
        else {
            let model2 = TroopLockedDataModel()
            model2.troopLockedTitle = "Unlock at hood level 10"
            
            hoodTableData.append(model2)
        }
        if (Int(user.hood) >= 25) {
            let model3 = TroopDataModel()
            model3.troopName = "Crip"
            model3.troopHealth = "Health: 50"
            model3.troopAttack = "Attack: 15"
            model3.troopCost = "Cost: $12500"
            model3.troopImage = UIImage(named: "crip")!
            model3.troopQuantity = "Quantity: " + user.crips
            model3.troopIdentifier = "crips"
            
            hoodTableData.append(model3)
        }
        else {
            let model3 = TroopLockedDataModel()
            model3.troopLockedTitle = "Unlock at hood level 25"
            
            hoodTableData.append(model3)
        }
        
        myTableView.reloadData()
        
        assistantTextView.text = "Here you can buy troops to battle other players. Your attack and endurance stat determines how much stronger your goons are during battle. Every attack stat you have increases your troops attack by 0.1% and endurance increases your troops health by 0.1% each level."
    }
    
    func populateAssetTableData() {
        hoodTableData = [AnyObject]()
        assets = [AssetDataModel(title: "Hood", identifier: "hood", level: user.hood, cost: String(5000 * Int((Double(user.hood)! * 2.0))), assetDescription: "Increases max level of all other assets by 10 for each level"), AssetDataModel(title: "March Size", identifier: "march_size", level: user.marchSize, cost: String(1000 * Int(Double(user.marchSize)! * 1.7)), assetDescription: "Increases the amount of each troop used when attacking and defending by 100"), AssetDataModel(title: "Junkie Tactics", identifier : "junkie_tactics", level: user.junkieTactics, cost: String(1000 * Int(Double(user.junkieTactics)! * 1.7)), assetDescription: "Increases attack by 0.1% and health by 1% of junkies during battle per level"), AssetDataModel(title: "Baller Tactics", identifier: "baller_tactics", level: user.ballerTactics, cost: String(1000 * Int(Double(user.ballerTactics)! * 1.7)), assetDescription: "Increase attack by 0.1% and health by 1% of ballers during battle per level"), AssetDataModel(title: "Crip Tactics", identifier: "crip_tactics", level: user.cripTactics, cost: String(1000 * Int(Double(user.cripTactics)! * 1.7)), assetDescription: "Increases attack by 0.1% and health by 1% of crips during battle per level")]
        
        for asset in assets {
            hoodTableData.append(asset)
        }
        
        myTableView.reloadData()
        
        assistantTextView.text = "Here you can upgrade your assets to make your hood stronger and more effecient. Your reputation as a hustler is proportionate to the level of your hood. Make sure your ready to deal with the competition as you grow. A big hustler is a big target."
        
    }
    
    func populateEquipmentData() {
        hoodTableData = [AnyObject]()
        let model = EquipmentDataModel(image: UIImage(named: "baseball_bat")!, name: "Baseball Bat", attack: "5", protection: "0", cost: "25", identifier: "baseball_bat")
        
        for currentEquipment in activeEquipment {
            if let identifier = currentEquipment["active_equipment_identifier"] as? String {
                if identifier == model.equipmentIdentifier {
                    if let quantity = currentEquipment["active_equipment_quantity"] as? String {
                        model.equipmentQuantity = quantity
                    }
                }
            }
        }
        hoodTableData.append(model);
        
        
        if (Int(user.hood) >= 25) {
            let model = EquipmentDataModel(image: UIImage(named: "combat_knife")!, name: "Combat Knife", attack: "15", protection: "0", cost: "250", identifier: "combat_knife")
            
            for currentEquipment in activeEquipment {
                if let identifier = currentEquipment["active_equipment_identifier"] as? String {
                    if identifier == model.equipmentIdentifier {
                        if let quantity = currentEquipment["active_equipment_quantity"] as? String {
                            model.equipmentQuantity = quantity
                        }
                    }
                }
            }
            hoodTableData.append(model)
        }
        else {
            let model = TroopLockedDataModel()
            model.troopLockedTitle = "Unlock at hood level 25"
            
            hoodTableData.append(model)
        }
        if (Int(user.hood) >= 50) {
            let model = EquipmentDataModel(image: UIImage(named: "baretta")!, name: "Baretta", attack: "45", protection: "0", cost: "1200", identifier: "baretta")
            
            for currentEquipment in activeEquipment {
                if let identifier = currentEquipment["active_equipment_identifier"] as? String {
                    if identifier == model.equipmentIdentifier {
                        if let quantity = currentEquipment["active_equipment_quantity"] as? String {
                            model.equipmentQuantity = quantity
                        }
                    }
                }
            }
            hoodTableData.append(model)
        }
        else {
            let model = TroopLockedDataModel()
            model.troopLockedTitle = "Unlock at hood level 50"
            
            hoodTableData.append(model)
        }
        
        myTableView.reloadData()
        
        assistantTextView.text = "Here you can buy equipment to get your goons strapped for fights. Every goon you send to fight uses a weapon and disposes of it when the job is done. Remember, these dudes is monstas so there gonna use any and everything you give em. So much sure you hustle hard and keep them boys ready for action."
    }
    
    func setEquipmentQuantity (equipment : NSArray) {
        for currentEquipment in equipment {
            for model in hoodTableData {
                if let equipmentModel = model as? EquipmentDataModel {
                    if let currentEquipmentIdentifier = currentEquipment["active_equipment_identifier"] as? String {
                        if currentEquipmentIdentifier == equipmentModel.equipmentIdentifier {
                            if let quantity = currentEquipment["active_equipment_quantity"] as? String {
                                equipmentModel.equipmentQuantity = quantity
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getActiveEquipment() {
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        loadingView.show()
        
        webService.getActiveEquipment(user.accountId, deviceId: deviceId, onComplete: { (json) in
            loadingView.terminate()
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let equipment = json["active_equipment"] as? NSArray {
                        self.activeEquipment = equipment as! [NSDictionary]
                        if self.currentTab == Tab.equipment {
                            self.populateEquipmentData()
                        }
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
