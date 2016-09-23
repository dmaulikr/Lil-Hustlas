//
//  PropertiesViewController.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 9/2/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class PropertiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var assistantTextView: UITextView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var chatTextView: UITextView!
    
    let util = Util()
    let webservice = Webservice()
    let user = User.sharedInstance
    let socket = Socket.getInstance()
    let chatList = ChatList.sharedInstance
    
    var tableData = [AnyObject]();
    var selectedFightResult : NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.registerNib(UINib(nibName: "PropertiesTableCell", bundle: nil), forCellReuseIdentifier: "PropertiesTableCell")
        myTableView.registerNib(UINib(nibName: "OwnedPropertiesTableCell", bundle: nil), forCellReuseIdentifier: "OwnedPropertiesTableCell")
        getProperties()
    }
    
    override func viewDidAppear(animated: Bool) {
        socket.view = self
        updateUserDataFromSingleton()
        self.setChat()
        
        assistantTextView.text = "This is where you manage your turfs. Turfs are properties you control by having your goons guard them. You need to make sure your turfs are protected or a rival hustla will come and take them from you. Having turfs gives you some money and resources every half hour like goons and weapons. You can attack an enemy turf and attempt to take control of it if you think you got the man and fire power."
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TurfsToFightResult" {
            let viewController = segue.destinationViewController as! FightResultViewController
            viewController.fightResult = selectedFightResult
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSegment(sender : AnyObject) {
        let segment = sender as! UISegmentedControl
        
        if segment.selectedSegmentIndex == 0 {
            getProperties()
        }
        else if segment.selectedSegmentIndex == 1 {
            getCurrentUserProperties()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableData[indexPath.row] is PropertiesDataModel {
            return 75.0
        }
        else if tableData[indexPath.row] is OwnedPropertiesDataModel {
            return 125.0
        }
        
        return 75.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let model = tableData[indexPath.row] as? PropertiesDataModel {
            let cell = tableView.dequeueReusableCellWithIdentifier("PropertiesTableCell", forIndexPath: indexPath) as! PropertiesTableCell
            
            cell.propertyImageView.image = UIImage(named: model.propertyImageString)!
            cell.nameLabel.text = model.propertyName
            cell.ownerLabel.text = model.ownerUsername
            cell.powerLabel.text = model.propertyPower
            cell.attackButton.tag = indexPath.row
            cell.attackButton.addTarget(self, action: #selector(PropertiesViewController.onAttackButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
        }
        else if let model = tableData[indexPath.row] as? OwnedPropertiesDataModel {
            let cell = tableView.dequeueReusableCellWithIdentifier("OwnedPropertiesTableCell", forIndexPath: indexPath) as! OwnedPropertiesTableCell
            
            cell.propertyImageView.image = UIImage(named: model.propertyImageString)
            cell.propertyNameLabel.text = model.propertyName
            cell.junkiesLabel.text = model.propertyJunkies
            cell.ballersLabel.text = model.propertyBallers
            cell.cripsLabel.text = model.propertyCrips
            cell.powerLabel.text = model.propertyPower
            cell.addJunkiesButton.tag = indexPath.row
            cell.addBallersButton.tag = indexPath.row
            cell.addCripsButton.tag = indexPath.row
            cell.addJunkiesButton.addTarget(self, action: #selector(PropertiesViewController.onAddJunkiesButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.addBallersButton.addTarget(self, action: #selector(PropertiesViewController.onAddBallersButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.addCripsButton.addTarget(self, action: #selector(PropertiesViewController.onAddCripsButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    func onAttackButton (sender : UIButton) {
        let model = tableData[sender.tag] as! PropertiesDataModel
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        loadingView.show()
        
        webservice.attackProperty(user.accountId, deviceId: deviceId, propertyId: model.propertyId, onComplete: { (json) in
            loadingView.terminate()
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let taken = json["taken"] as? Bool {
                        if taken == true {
                            self.util.getAlertForSuccess(self, message: "You have taken control of this turf.")
                        }
                        else {
                            if let fightResult = json["fightResult"] as? NSDictionary {
                                self.selectedFightResult = fightResult
                                self.performSegueWithIdentifier("TurfsToFightResult", sender: self)
                            }
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
                loadingView.terminate();
        }
    }
    
    func onAddJunkiesButton (sender : UIButton) {
        if let model = tableData[sender.tag] as? OwnedPropertiesDataModel {
            let alert = UIAlertController(title: "Quantity", message: "Note that once you send goons to guard a turf, you cannot get them back.", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addTextFieldWithConfigurationHandler { (textField : UITextField) in
                textField.placeholder = "How Many?";
                textField.keyboardType = UIKeyboardType.NumberPad;
            }
            alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler: { (action : UIAlertAction) in
                let textField = alert.textFields![0];
                if let quantity = Int(textField.text!) {
                    self.reinforceProperty(model.propertyId, troopIdentifier: "junkies", quantity: quantity)
                }
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func onAddBallersButton (sender : UIButton) {
        if let model = tableData[sender.tag] as? OwnedPropertiesDataModel {
            let alert = UIAlertController(title: "Quantity", message: "Note that once you send goons to guard a turf, you cannot get them back.", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addTextFieldWithConfigurationHandler { (textField : UITextField) in
                textField.placeholder = "How Many?";
                textField.keyboardType = UIKeyboardType.NumberPad;
            }
            alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler: { (action : UIAlertAction) in
                let textField = alert.textFields![0];
                if let quantity = Int(textField.text!) {
                    self.reinforceProperty(model.propertyId, troopIdentifier: "ballers", quantity: quantity)
                }
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func onAddCripsButton (sender : UIButton) {
        if let model = tableData[sender.tag] as? OwnedPropertiesDataModel {
            let alert = UIAlertController(title: "Quantity", message: "Note that once you send goons to guard a turf, you cannot get them back.", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addTextFieldWithConfigurationHandler { (textField : UITextField) in
                textField.placeholder = "How Many?";
                textField.keyboardType = UIKeyboardType.NumberPad;
            }
            alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler: { (action : UIAlertAction) in
                let textField = alert.textFields![0];
                if let quantity = Int(textField.text!) {
                    self.reinforceProperty(model.propertyId, troopIdentifier: "crips", quantity: quantity)
                }
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func reinforceProperty(propertyId : String, troopIdentifier : String, quantity : Int) {
        let deviceId = UIDevice().identifierForVendor!.UUIDString
        let loading = LoadingView(message: "Loading...", parentView: self.view)
        loading.show()
        
        self.webservice.addTroopsToProperty(self.user.accountId, deviceId: deviceId, propertyId: propertyId, troopIdentifier: troopIdentifier, quantity: String(quantity), onComplete: { (json) in
            loading.terminate()
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let properties = json["properties"] as? NSArray {
                        self.populateOwnedPropertiesTableData(properties)
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
                loading.terminate()
                self.util.getAlertForError(self)
        })
    }
    
    func getProperties() {
        tableData = [AnyObject]()
        myTableView.reloadData()
        
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loading = LoadingView(message: "Loading....", parentView: self.view)
        loading.show()
        
        webservice.getProperties(user.accountId, deviceId: deviceId, onComplete: { (json) in
            loading.terminate()
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let properties = json["properties"] as? NSArray {
                        self.populateTableData(properties)
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
                loading.terminate()
                self.util.getAlertForError(self)
        }
    }
    
    func getCurrentUserProperties() {
        tableData = [AnyObject]()
        myTableView.reloadData()
        
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loading = LoadingView(message: "Loading...", parentView: self.view)
        loading.show()
        
        webservice.getPropertiesForCurrentUser(user.accountId, deviceId: deviceId, onComplete: { (json) in
            loading.terminate()
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let properties = json["properties"] as? NSArray {
                        self.populateOwnedPropertiesTableData(properties)
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
                loading.terminate()
                self.util.getAlertForError(self)
        }
    }
    
    func populateOwnedPropertiesTableData (properties : NSArray) {
        tableData = [AnyObject]()
        
        for property in properties {
            let model = OwnedPropertiesDataModel()
            
            if let propertyId = property["property_id"] as? String {
                model.propertyId = propertyId
            }
            if let propertyIdentifier = property["property_identifier"] as? String {
                model.propertyIdentifier = propertyIdentifier
            }
            if let propertyName = property["property_name"] as? String {
                model.propertyName = propertyName
            }
            if let propertyPower = property["power"] as? String {
                model.propertyPower = propertyPower
            }
            if let propertyImageString = property["property_image"] as? String {
                model.propertyImageString = propertyImageString
            }
            if let propertyPower = property["power"] as? String {
                model.propertyPower = propertyPower
            }
            if let propertyJunkies = property["junkies"] as? String {
                model.propertyJunkies = propertyJunkies
            }
            if let propertyBallers = property["ballers"] as? String {
                model.propertyBallers = propertyBallers
            }
            if let propertyCrips = property["crips"] as? String {
                model.propertyCrips = propertyCrips
            }
            
            tableData.append(model)
        }
        
        myTableView.reloadData()
    }
    
    func populateTableData (properties : NSArray) {
        tableData = [AnyObject]()
        
        for property in properties {
            let model = PropertiesDataModel()
            
            if let propertyId = property["property_id"] as? String {
                model.propertyId = propertyId
            }
            if let propertyIdentifier = property["property_identifier"] as? String {
                model.propertyIdentifier = propertyIdentifier
            }
            if let propertyName = property["property_name"] as? String {
                model.propertyName = propertyName
            }
            if let propertyImageString = property["property_image"] as? String {
                model.propertyImageString = propertyImageString
            }
            if let propertyPower = property["power"] as? String {
                model.propertyPower = propertyPower
            }
            if let ownerId = property["owner_id"] as? String {
                model.ownerId = ownerId
            }
            if let ownerUsername = property["owner_username"] as? String {
                model.ownerUsername = ownerUsername
            }
            
            self.tableData.append(model);
        }
        
        myTableView.reloadData()
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
    func updateUserDataFromSingleton() {
        moneyLabel.text = "$ " + user.money
        levelLabel.text = "Lvl: " + user.level
        powerLabel.text = "Power: " + user.power
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
