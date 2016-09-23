//
//  Util.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/15/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class Util: NSObject {
    func getAlertForSuccess (view : UIViewController, message : String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil));
        
        view.presentViewController(alert, animated: true, completion: nil);
    }
    
    func getAlertForError (view : UIViewController, message : String = "Something went wrong. Please check your internet connection and try again.") {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil));
        
        view.presentViewController(alert, animated: true, completion: nil);
    }
    
    func getAlertForForLevelUp (view : UIViewController) {
        let alert = UIAlertController(title: "Level Up", message: "Trillz. Remember, you get more exp from hustles the higher your mastery of that hustle is. You also get exp from killing other hustla's goons. The higher the hustla's hood and level, the more exp you get for knockin off their goons. Keep grindin!\n+1 stat point\n+1 Eenrgy", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "Mmhm", style: UIAlertActionStyle.Default, handler: nil));
        
        view.presentViewController(alert, animated: true, completion: nil);
    }
    
    func getAlertForForMasteryUp (view : UIViewController) {
        let alert = UIAlertController(title: "Mastery Up", message: "Your mastery of this hustle has increased. You gain 1% more money and exp for each mastery level you have so keep hustlin!\n+1 stat points", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "Mmhm", style: UIAlertActionStyle.Default, handler: nil));
        
        view.presentViewController(alert, animated: true, completion: nil);
    }
    
    
    func getPower (user : NSDictionary) -> String {
        var power = ""
        
        if let hood = user["hood"] as? String {
            if let level = user["level"] as? String {
                if let junkies = user["junkies"] as? String {
                    if let ballers = user["ballers"] as? String {
                        if let crips = user["crips"] as? String {
                            let junkiesPower = Int(Int(junkies)! / 10)
                            let ballersPower = Int(Int(ballers)! / 8)
                            let cripsPower = Int(Int(crips)! / 6)
                            power = String((Int(level)! + Int(hood)!) * (junkiesPower + ballersPower + cripsPower))
                            
                            return power
                        }
                    }
                }
            }
        }
        
        return ""
    }
    
    func getPowerFromUserSingleton (user : User) -> String {
        var power = ""
        
        let junkiesPower = Int(Int(user.junkies)! / 10)
        let ballersPower = Int(Int(user.ballers)! / 8)
        let cripsPower = Int(Int(user.crips)! / 6)
        power = String((Int(user.level)! + Int(user.hood)!) * (junkiesPower + ballersPower + cripsPower))
        
        return power
    }
    
    func getEnergyBar (number : NSNumber) -> UIImage {
        let name = "energy_bar_";
        
        let percent = number.integerValue;
        
        if (percent > 95) {
            return UIImage(named : "energy_bar.png")!;
        }
        else if (percent > 90 && percent <= 95) {
            return UIImage(named : "energy_bar95.png")!;
        }
        else if (percent > 85 && percent <= 90) {
            return UIImage(named : name + "90.png")!;
        }
        else if (percent > 80 && percent <= 85) {
            return UIImage (named : name + "85.png")!;
        }
        else if (percent > 75 && percent <= 80) {
            return UIImage(named : name + "80.png")!;
        }
        else if (percent > 70 && percent <= 75) {
            return UIImage(named : name + "75.png")!;
        }
        else if (percent > 65 && percent <= 70) {
            return UIImage (named : name + "70.png")!;
        }
        else if (percent > 60 && percent <= 65) {
            return UIImage (named : name + "65.png")!;
        }
        else if (percent > 55 && percent <= 60) {
            return UIImage (named : name + "60.png")!;
        }
        else if (percent > 50 && percent <= 55) {
            return UIImage (named : name + "55.png")!;
        }
        else if (percent > 45 && percent <= 50) {
            return UIImage (named : name + "50.png")!;
        }
        else if (percent > 40 && percent <= 45) {
            return UIImage (named : name + "45.png")!;
        }
        else if (percent > 35 && percent <= 40) {
            return UIImage (named : name + "40.png")!;
        }
        else if (percent > 30 && percent <= 35) {
            return UIImage (named : name + "35.png")!;
        }
        else if (percent > 25 && percent <= 30) {
            return UIImage (named : name + "30.png")!;
        }
        else if (percent > 20 && percent <= 25) {
            return UIImage (named : name + "25.png")!;
        }
        else if (percent > 15 && percent <= 25) {
            return UIImage (named : name + "20.png")!;
        }
        else if (percent > 10 && percent <= 15) {
            return UIImage (named : name + "15.png")!;
        }
        else if (percent > 5 && percent <= 10) {
            return UIImage (named : name + "10.png")!;
        }
        else if (percent > 1 && percent <= 5) {
            return UIImage (named : name + "5.png")!;
        }
        else if (percent == 1) {
            return UIImage (named : name + "1.png")!;
        }
        else {
            return UIImage (named : "empty_bar.png")!;
        }
    }
    
    func getAuraBar (number : NSNumber) -> UIImage {
        let name = "aura_bar_";
        
        let percent = number.integerValue;
        
        if (percent > 95) {
            return UIImage(named : name + "100.png")!;
        }
        else if (percent > 90 && percent <= 95) {
            return UIImage(named : name + "95.png")!;
        }
        else if (percent > 85 && percent <= 90) {
            return UIImage(named : name + "90.png")!;
        }
        else if (percent > 80 && percent <= 85) {
            return UIImage (named : name + "85.png")!;
        }
        else if (percent > 75 && percent <= 80) {
            return UIImage(named : name + "80.png")!;
        }
        else if (percent > 70 && percent <= 75) {
            return UIImage(named : name + "75.png")!;
        }
        else if (percent > 65 && percent <= 70) {
            return UIImage (named : name + "70.png")!;
        }
        else if (percent > 60 && percent <= 65) {
            return UIImage (named : name + "65.png")!;
        }
        else if (percent > 55 && percent <= 60) {
            return UIImage (named : name + "60.png")!;
        }
        else if (percent > 50 && percent <= 55) {
            return UIImage (named : name + "55.png")!;
        }
        else if (percent > 45 && percent <= 50) {
            return UIImage (named : name + "50.png")!;
        }
        else if (percent > 40 && percent <= 45) {
            return UIImage (named : name + "45.png")!;
        }
        else if (percent > 35 && percent <= 40) {
            return UIImage (named : name + "40.png")!;
        }
        else if (percent > 30 && percent <= 35) {
            return UIImage (named : name + "35.png")!;
        }
        else if (percent > 25 && percent <= 30) {
            return UIImage (named : name + "30.png")!;
        }
        else if (percent > 20 && percent <= 25) {
            return UIImage (named : name + "25.png")!;
        }
        else if (percent > 15 && percent <= 25) {
            return UIImage (named : name + "20.png")!;
        }
        else if (percent > 10 && percent <= 15) {
            return UIImage (named : name + "15.png")!;
        }
        else if (percent > 5 && percent <= 10) {
            return UIImage (named : name + "10.png")!;
        }
        else if (percent > 1 && percent <= 5) {
            return UIImage (named : name + "5.png")!;
        }
        else if (percent == 1) {
            return UIImage (named : name + "1.png")!;
        }
        else {
            return UIImage (named : "empty_bar.png")!;
        }
    }
}
