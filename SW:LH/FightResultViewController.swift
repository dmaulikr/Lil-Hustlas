//
//  FightResultViewController.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/31/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class FightResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myNavigationBar: UINavigationBar!
    @IBOutlet weak var attackerJunkiesLost: UILabel!
    @IBOutlet weak var attackerBallersLost: UILabel!
    @IBOutlet weak var attackerCripsLost: UILabel!
    @IBOutlet weak var defenderJunkiesLost: UILabel!
    @IBOutlet weak var defenderBallersLost: UILabel!
    @IBOutlet weak var defenderCripsLost: UILabel!
    @IBOutlet weak var attackerAvatarImageView: UIImageView!
    @IBOutlet weak var attackerUsernameLabel: UILabel!
    @IBOutlet weak var defenderAvatarImageView: UIImageView!
    @IBOutlet weak var defenderUsernameLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var winLoseLabel: UILabel!
    
    var fightResult : NSDictionary!
    var won : Bool!;
    var tableData = [RoundDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.registerNib(UINib(nibName: "RoundTableCell", bundle: nil), forCellReuseIdentifier: "RoundTableCell")
        initFightResult()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton (sender : AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = tableData[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("RoundTableCell", forIndexPath: indexPath) as! RoundTableCell
        
        cell.roundTextView.text = model.roundText
        
        return cell
    }
    
    func initFightResult() {
        if let attackerAvatar = fightResult["attacker_avatar"] as? String {
            attackerAvatarImageView.image = UIImage(named: attackerAvatar)
        }
        if let attackerUsername = fightResult["attacker_username"] as? String {
            self.attackerUsernameLabel.text = attackerUsername
        }
        if let attackerJunkiesLost = fightResult["attacker_junkies_lost"] as? NSNumber {
            self.attackerJunkiesLost.text = "-" + String(attackerJunkiesLost)
        }
        if let attackerBallersLost = fightResult["attacker_ballers_lost"] as? NSNumber {
            self.attackerBallersLost.text = "-" + String(attackerBallersLost)
        }
        if let attackerCripsLost = fightResult["attacker_crips_lost"] as? NSNumber {
            self.attackerCripsLost.text = "-" + String(attackerCripsLost)
        }
        if let attackerWon = fightResult["attacker_won"] as? Bool {
            if attackerWon == true {
                self.winLoseLabel.textColor = UIColor.greenColor()
                self.winLoseLabel.text = "Win!"
            }
            else {
                self.winLoseLabel.textColor = UIColor.redColor()
                self.winLoseLabel.text = "Lose!"
            }
        }
        if let defenderAvatar = fightResult["defender_avatar"] as? String {
            defenderAvatarImageView.image = UIImage(named: defenderAvatar)
        }
        if let defenderUsername = fightResult["defender_username"] as? String {
            defenderUsernameLabel.text = defenderUsername
        }
        if let defenderJunkiesLost = fightResult["defender_junkies_lost"] as? NSNumber {
            self.defenderJunkiesLost.text = "-" + String(defenderJunkiesLost)
        }
        if let defenderBallersLost = fightResult["defender_ballers_lost"] as? NSNumber {
            self.defenderBallersLost.text = "-" + String(defenderBallersLost)
        }
        if let defenderCripsLost = fightResult["defender_crips_lost"] as? NSNumber {
            self.defenderCripsLost.text = "-" + String(defenderCripsLost)
        }
        
        setRoundData(fightResult)
    }
    
    func setRoundData(fightResult : NSDictionary) {
        for count in 1...10 {
            if let roundText = fightResult["round" + String(count)] as? String {
                let model = RoundDataModel()
                model.roundText = roundText
                
                tableData.append(model)
            }
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
