//
//  Webservice+equipment.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 8/6/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

extension Webservice {
    func buyEquipment(accountId : String, deviceId : String, equipmentIdentifier : String, quantity : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/buy_equipment/" + accountId + "/" + deviceId + "/" + equipmentIdentifier + "/" + quantity;
        
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
    
    func getActiveEquipment(accountId : String, deviceId : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/get_active_equipment/" + accountId + "/" + deviceId
        
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
