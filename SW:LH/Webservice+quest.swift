//
//  Webservice+quest.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/15/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

extension Webservice {
    func getMissions(accountId : String, deviceId : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/get_missions/" + accountId + "/" + deviceId;
        
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
    }
    
    func doMission(accountId : String, deviceId : String, missionId : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/do_mission/" + accountId + "/" + deviceId + "/" + missionId;
        
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
    }
}
