//
//  Webservice+property.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 9/2/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

extension Webservice {
    func getProperties(accountId : String, deviceId : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/get_properties/" + accountId + "/" + deviceId
        
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
    
    func attackProperty(accountId : String, deviceId : String, propertyId : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/attack_property/" + accountId + "/" + deviceId + "/" + propertyId
        
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
    
    func getPropertiesForCurrentUser(accountId : String, deviceId : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/get_properties_for_current_user/" + accountId + "/" + deviceId
        
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
    
    func addTroopsToProperty(accountId : String, deviceId : String, propertyId : String, troopIdentifier : String, quantity : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/add_troops_to_property/" + accountId + "/" + deviceId + "/" + propertyId + "/" + troopIdentifier + "/" + quantity;
        
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
