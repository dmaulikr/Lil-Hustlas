//
//  Webservice+user.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/15/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

extension Webservice {
    func login(accountId : String, deviceId : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/login/" + accountId + "/" + deviceId;
        
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
    
    func getUser(accountId : String, deviceId : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/get_user/" + accountId + "/" + deviceId;
        
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
    
    func restUser(accountId : String, deviceId : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/rest_user/" + accountId + "/" + deviceId;
        
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
    
    func upgradeStat(accountId : String, deviceId : String, statIdentifier : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/upgrade_stat/" + accountId + "/" + deviceId + "/" + statIdentifier;
        
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
    
    func selectAvatar(accountId : String, deviceId : String, avatarIdentifier : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/select_avatar/" + accountId + "/" + deviceId + "/" + avatarIdentifier;
        
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
    
    func upgradeAsset(accountId : String, deviceId : String, assetIdentifier : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/upgrade_asset/" + accountId + "/" + deviceId + "/" + assetIdentifier;
        
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
    
    func buyTroops(accountId : String, deviceId : String, quantity : String, troopIdentifier : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/buy_troops/" + accountId + "/" + deviceId + "/" + quantity + "/" + troopIdentifier
        
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
    
    func getFightList(accountId : String, deviceId : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/get_fight_list/" + accountId + "/" + deviceId
        
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
    
    func attack_user(accountId : String, deviceId : String, userId : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/attack_user/" + accountId + "/" + deviceId + "/" + userId
        
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
    
    func get_leaderboard(accountId : String, deviceId : String, criteria : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/get_leaderboard/" + accountId + "/" + deviceId + "/" + criteria
        
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
    
    func setUsername(accountId : String, deviceId : String, username : String, onComplete: (json : NSDictionary) -> (), onError: () -> ()) {
        let host = self.host + "/set_username/" + accountId + "/" + deviceId + "/" + username
        
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
