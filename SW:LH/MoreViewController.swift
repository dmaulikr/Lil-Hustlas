//
//  MoreViewController.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/9/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    let webService = Webservice()
    let util = Util()
    let user = User.sharedInstance
    let notification = Notification.sharedInstance
    let tabTitles = ["Leaderboard", "World Chat", "Notifications", "Logout"]
    let tabImages = [UIImage(named: "leaderboard"), UIImage(named: "world_chat"), UIImage(named: "achievements"), UIImage(named: "logout")]
    let socket = Socket.getInstance()
    
    var collectionData = [MoreDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myCollectionView.registerNib(UINib(nibName: "MoreTableCell", bundle: nil), forCellWithReuseIdentifier: "MoreTableCell")
        
        initMoreTabs()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.tabBar.items![4].badgeValue = nil
        notification.notifications = [NSObject]()
        socket.view = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let model = collectionData[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MoreTableCell", forIndexPath: indexPath) as! MoreTableCell
        
        cell.moreTabImageView.image = model.moreTabImage
        cell.moreTabTitleLabel.text = model.moreTabTitle
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = collectionData[indexPath.row]
        
        if (model.moreTabTitle == "Leaderboard") {
            self.performSegueWithIdentifier("MoreToLeaderboard", sender: self)
        }
        else if (model.moreTabTitle == "World Chat") {
            self.performSegueWithIdentifier("MoreToChat", sender: self)
        }
        else if (model.moreTabTitle == "Notifications") {
            self.performSegueWithIdentifier("MoreToNotifications", sender: self)
        }
        else if (model.moreTabTitle == "Logout") {
            //Disconnect socket and wait for disconnect event in Socket class
            //Then dismiss the view controller
            self.socket.socket.disconnect()
            self.socket.socket.removeAllHandlers()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func initMoreTabs() {
        for i in 0..<tabTitles.count {
            let model = MoreDataModel()
            model.moreTabTitle = tabTitles[i]
            
            collectionData.append(model)
        }
        
        myCollectionView.reloadData()
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
