//
//  Webservice+notification.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/15/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

extension Webservice {
    func getNotifications(accountId : String, deviceId : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/get_notifications/" + accountId + "/" + deviceId
        
        let url = NSURL(string: host);
        
        let request = NSMutableURLRequest(URL: url!);
        request.HTTPMethod = "GET";
        request.addValue("application/json", forHTTPHeaderField: "Accept");
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration();
        let session = NSURLSession(configuration: config);
        
        let task = session.dataTaskWithRequest(request, completionHandler:{ (data : NSData?, response: NSURLResponse?, error : NSError?) -> Void in
            if (error == nil) {
                if let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        onComplete(json: json);
                    });
                }
            }
        });
        
        task.resume();
    }}
