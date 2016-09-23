//
//  LeaderboardViewController.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/9/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTableView: UITableView!
    
    let webService = Webservice()
    let util = Util()
    let user = User.sharedInstance
    
    var tableData = [LeaderboardDataModel]()
    var criteria = "power"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initLeaderboard()
        myTableView.registerNib(UINib(nibName: "LeaderboardTableCell", bundle: nil), forCellReuseIdentifier: "LeaderboardTableCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton (sender : AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCriteriaButton (sender : AnyObject) {
        switch (sender.tag) {
        case 1:
            criteria = "power"
            break;
        case 2:
            criteria = "fights"
            break;
        case 3:
            criteria = "kills"
            break;
        case 4:
            criteria = "wins"
            break;
        case 5:
            criteria = "missions"
            break;
        default:
            break;
            
        }
        
        initLeaderboard()
    }
    
    @IBAction func onSegment (sender : AnyObject) {
        if let segment = sender as? UISegmentedControl {
            switch (segment.selectedSegmentIndex) {
            case 0:
                criteria = "power"
                break;
            case 1:
                criteria = "wins"
                break;
            case 2:
                criteria = "kills"
                break;
            case 3:
                criteria = "missions"
                break;
            case 4:
                criteria = "attack"
                break;
            case 5:
                criteria = "endurance"
                break;
            case 6:
                criteria = "hustle"
                break;
            default:
                break;
                
            }
            
            initLeaderboard()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 125.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = tableData[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("LeaderboardTableCell", forIndexPath: indexPath) as! LeaderboardTableCell
        
        cell.avatarImageView.image = model.avatarImage
        cell.usernameLabel.text = model.username
        cell.powerLabel.text = model.power
        cell.fightsLabel.text = model.fights
        cell.killsLabel.text = model.kills
        cell.winsLabel.text = model.wins
        cell.lossesLabel.text = model.losses
        cell.missionsLabel.text = model.missions
        cell.rankLabel.text = "Rank " + model.rank
        
        return cell
    }
    
    
    func initLeaderboard() {
        tableData = [LeaderboardDataModel]()
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loadingView = LoadingView(message: "Loading...", parentView: self.view)
        loadingView.show()
        
        webService.get_leaderboard(user.accountId, deviceId: deviceId, criteria: criteria, onComplete: { (json) in
            loadingView.terminate()
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let leaderboard = json["leaderboard"] as? NSArray {
                        self.populateTableData(leaderboard)
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
    
    func populateTableData(leaderboard : NSArray) {
        var rank = 1
        for currentUser in leaderboard {
            let model = LeaderboardDataModel()
            if let username = currentUser["username"] as? String {
                model.username = username
            }
            if let fights = currentUser["fights"] as? String {
                model.fights = fights
            }
            if let kills = currentUser["kills"] as? String {
                model.kills = kills
            }
            if let wins = currentUser["wins"] as? String {
                model.wins = wins
            }
            if let losses = currentUser["losses"] as? String {
                model.losses = losses
            }
            if let missions = currentUser["missions"] as? String {
                model.missions = missions
            }
            if let avatar = currentUser["avatar"] as? String {
                model.avatarImage = UIImage(named: avatar)!
            }
            if let power = currentUser["power"] as? String {
                model.power = power
            }
            
            model.rank = String(rank)
            rank += 1
            
            tableData.append(model)
        }
        
        myTableView.reloadData()
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
