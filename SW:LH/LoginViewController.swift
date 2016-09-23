//
//  LoginViewController.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/15/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit
import Accounts

class LoginViewController: UIViewController {
    let webservice = Webservice()
    let util = Util()
    let user = User.sharedInstance
    let notification = Notification.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginWithDeviceButton (sender : AnyObject) {
        //When logging in with device, the accountId and deviceId are the same
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString;
        let accountId = deviceId;
        let loadingView = LoadingView(message: "Loading...", parentView: self.view);
        loadingView.show();
        
        webservice.login(accountId, deviceId: deviceId, onComplete: { (json) in
            loadingView.terminate();
            
            self.user.accountId = accountId;
            
            if let status = json["status"] as? NSNumber {
                if status == 200 {
                    //Connect socket to client
                    let socket = Socket.getInstance();
                    socket.socket.connect();
                    socket.initHandlers();
                    
                    if let notifications = json["notifications"] as? NSArray {
                        for _ in notifications {
                            self.notification.notifications.append("")
                        }
                    }
                    if let hasAvatar = json["hasAvatar"] as? Bool {
                        if (hasAvatar) {
                            self.performSegueWithIdentifier("LoginToTabs", sender: self)
                        }
                        else {
                            self.performSegueWithIdentifier("LoginToSelectAvatar", sender: self)
                        }
                    }
                }
                else {
                    if let errorMessage = json["errorMessage"] as? String {
                        self.util.getAlertForError(self, message: errorMessage);
                    }
                }
            }
            }) { 
                self.util.getAlertForError(self);
        }
    }
    
    @IBAction func onLoginWithFacebookButton (sender : AnyObject) {
        let accountStore = ACAccountStore();
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook);
        let options = [ACFacebookAppIdKey : "1074907265959017", ACFacebookPermissionsKey : ["public_profile"]];
        
        //Create and show loading indicator
        let loadingView = LoadingView(message: "Loading...", parentView: self.view);
        loadingView.show();
        
        accountStore.requestAccessToAccountsWithType(accountType, options: options) { (success: Bool, error : NSError!) -> Void in
            loadingView.terminate();
            
            if (success) {
                var accountsArray = accountStore.accountsWithAccountType(accountType)
                
                if accountsArray.count > 0 {
                    var facebookAccount = accountsArray[0] as! ACAccount
                    
                    print(facebookAccount.identifier);
                    
                    let accountId = facebookAccount.identifier
                    let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString;
                    
                    self.user.accountId = accountId
                    
                    self.webservice.login(accountId, deviceId: deviceId, onComplete: { (json) in
                        loadingView.terminate();
                        
                        self.user.accountId = accountId;
                        
                        //Connect socket to client
                        let socket = Socket.getInstance();
                        socket.socket.connect();
                        socket.initHandlers();
                        
                        if let status = json["status"] as? NSNumber {
                            if status == 200 {
                                if let notifications = json["notifications"] as? NSArray {
                                    for _ in notifications {
                                        self.notification.notifications.append("")
                                    }
                                }
                                
                                if let hasAvatar = json["hasAvatar"] as? Bool {
                                    if (hasAvatar) {
                                        self.performSegueWithIdentifier("LoginToTabs", sender: self)
                                    }
                                    else {
                                        self.performSegueWithIdentifier("LoginToSelectAvatar", sender: self)
                                    }
                                }
                            }
                            else {
                                if let errorMessage = json["errorMessage"] as? String {
                                    self.util.getAlertForError(self, message: errorMessage);
                                }
                            }
                        }
                    }) { 
                        self.util.getAlertForError(self);
                    }
                }
            }
            else {
                loadingView.terminate()
                self.util.getAlertForError(self, message: "There are no facebook accounts setup on this device. Tap the home button and go to settings. Scroll to Facebook and enter your Facebook credentials and try again.");
            }
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
