//
//  SelectAvatarViewController.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/18/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class SelectAvatarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    let avatarIdentifiers = ["avatar_male1_1", "avatar_male2_1", "avatar_male3_1", "avatar_femal1_1", "avatar_femal2_1", "avatar_femal3_1", "avatar_male1_2", "avatar_male2_2", "avatar_male3_2",
        "avatar_femal1_2", "avatar_femal2_2", "avatar_femal3_2"]
    let webService = Webservice()
    let util = Util()
    let user = User.sharedInstance
    var appeared = false
    
    var tableData = [AvatarDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name:"Munro", size: 24.0)!]
        myCollectionView.registerNib(UINib(nibName: "AvatarCollectionCell", bundle: nil), forCellWithReuseIdentifier: "AvatarCollectionCell")
        
        self.populateTableData()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (!appeared) {
            appeared = true
        }
        else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton (sender : AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarIdentifiers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AvatarCollectionCell", forIndexPath: indexPath) as! AvatarCollectionCell
        let model = tableData[indexPath.row]
        
        cell.avatarImageView.image = model.avatarImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = tableData[indexPath.row]
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let loading = LoadingView(message: "Loading...", parentView: self.view)
        loading.show()
        
        webService.selectAvatar(user.accountId, deviceId: deviceId, avatarIdentifier: model.avatarIdentifier, onComplete: { (json) in
            loading.terminate()
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    if let user = json["user"] as? NSDictionary {
                        if let username = user["username"] as? String {
                            if (username == "") {
                                self.performSegueWithIdentifier("SelectAvatarToSetUsername", sender: self)
                            }
                            else {
                                self.performSegueWithIdentifier("SelectAvatarToTabs", sender: self)
                            }
                        }
                        else {
                            self.performSegueWithIdentifier("SelectAvatarToSetUsername", sender: self)
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
    
    func populateTableData() {
        for identifier in avatarIdentifiers {
            let model = AvatarDataModel()
            model.avatarImage = UIImage(named: identifier)!
            model.avatarIdentifier = identifier
            
            tableData.append(model)
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
