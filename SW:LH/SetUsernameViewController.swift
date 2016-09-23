//
//  SetUsernameViewController.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/10/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class SetUsernameViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameTextField: UITextField!
    
    let webService = Webservice()
    let util = Util()
    let user = User.sharedInstance
    var loaded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if loaded == true {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            loaded = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSubmitUsername (sender : AnyObject) {
        var usernameText = usernameTextField.text!
        
        if (usernameText.stringByReplacingOccurrencesOfString(" ", withString: "") != "") {
            usernameText = usernameText.stringByReplacingOccurrencesOfString(" ", withString: "")
            let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
            let loadingView = LoadingView(message: "Loading...", parentView: self.view)
            
            self.webService.setUsername(user.accountId, deviceId: deviceId, username: usernameText, onComplete: { (json) in
                loadingView.terminate()
                
                if let status = json["status"] as? NSNumber {
                    if status == 200 {
                        self.performSegueWithIdentifier("SetUsernameToTabs", sender: self)
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
        else {
            self.util.getAlertForError(self, message: "Enter a username")
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
