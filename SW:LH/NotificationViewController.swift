//
//  NotificationViewController.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/15/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTableView: UITableView!
    
    let util = Util()
    let webService = Webservice()
    let user = User.sharedInstance
    
    var tableData = [AnyObject]()
    var selectedModel : FightResultNotificationDataModel!
    var selectedFightResult : NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.registerNib(UINib(nibName: "FightResultNotificationTableCell", bundle: nil), forCellReuseIdentifier: "FightResultNotificationTableCell")
        myTableView.registerNib(UINib(nibName: "NotificationTableCell", bundle: nil), forCellReuseIdentifier: "NotificationTableCell")
        getNotifications()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NotificationsToFightResult" {
            let viewController = segue.destinationViewController as! FightResultViewController
            viewController.fightResult = selectedFightResult;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButtonPressed (sender : AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let model = tableData[indexPath.row] as? FightResultNotificationDataModel {
            let cell = tableView.dequeueReusableCellWithIdentifier("FightResultNotificationTableCell", forIndexPath: indexPath) as! FightResultNotificationTableCell
            
            cell.notificationDescription.text = model.notificationDescription
            cell.notificationDate.text = model.notificationDate
            cell.retaliateButton.tag = indexPath.row
            cell.retaliateButton.addTarget(self, action: #selector(NotificationViewController.onRetaliateButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
        }
        if let model = tableData[indexPath.row] as? NotificationDataModel {
            let cell = tableView.dequeueReusableCellWithIdentifier("NotificationTableCell", forIndexPath: indexPath) as! NotificationTableCell
            
            cell.descriptionTextView.text = model.notificationDescription
            cell.dateLabel.text = model.notificationDate
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func getNotifications() {
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        
        loadingView.show()
        
        webService.getNotifications(user.accountId, deviceId: deviceId, onComplete: { (json) in
            loadingView.terminate()
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let notifications = json["notifications"] as? NSArray {
                        self.populateTableData(notifications)
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
    
    func populateTableData (notifications : NSArray) {
        for notification in notifications {
            if let isFightResult = notification["is_fight_result"] as? Bool {
                if (isFightResult) {
                    let model = FightResultNotificationDataModel()
                    if let notificationDescription = notification["notification_description"] as? String {
                        model.notificationDescription = notificationDescription
                    }
                    if let otherUserId = notification["other_user_id"] as? String {
                        model.otherUserId = otherUserId
                    }
                    if let notificationDate = notification["notification_time_stamp"] as? String {
                        let timeStamp = Double(notificationDate)!
                        let date = NSDate.init(timeIntervalSince1970: timeStamp / 1000)
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "EEE, dd MMM hh:mm:ss"
                        let dateString = dateFormatter.stringFromDate(date)
                        model.notificationDate = dateString
                    }
                    
                    tableData.append(model)
                }
                else {
                    let model = NotificationDataModel()
                    if let notificationDescription = notification["notification_description"] as? String {
                        model.notificationDescription = notificationDescription
                    }
                    if let notificationDate = notification["notification_time_stamp"] as? String {
                        let timeStamp = Double(notificationDate)!
                        let date = NSDate.init(timeIntervalSince1970: timeStamp / 1000)
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "EEE, dd MMM hh:mm:ss"
                        let dateString = dateFormatter.stringFromDate(date)
                        model.notificationDate = dateString
                    }
                    
                    tableData.append(model)
                }
            }
        }
        
        myTableView.reloadData()
    }
    
    func onRetaliateButton (sender : AnyObject) {
        let model = tableData[sender.tag] as! FightResultNotificationDataModel
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        loadingView.show()
        
        self.webService.attack_user(user.accountId, deviceId: deviceId, userId: model.otherUserId, onComplete: { (json) in
            loadingView.terminate()
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let user = json["user"] as? NSDictionary {
                        self.user.updateSingleton(user)
                    }
                    if let fightResult = json["fightResult"] as? NSDictionary {
                        self.selectedFightResult = fightResult
                        self.performSegueWithIdentifier("NotificationsToFightResult", sender: self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
