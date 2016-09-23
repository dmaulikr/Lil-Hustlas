//
//  LoadingView.swift
//  SW:LH
//
//  Created by Jalil Kennedy on 7/15/16.
//  Copyright © 2016 Jalil Kennedy. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    var activityIndicator:UIActivityIndicatorView!
    
    /*
     not yet implemented, but may want a message to appear on the loading screen
     that is specific to the data being loaded.
     */
    var message:String?
    var terminated = false
    var didShow = false
    var parentView:UIView?
    var timer : NSTimer!;
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    init(message:String,parentView:UIView?) {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        self.message = message
        self.parentView = parentView
        timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "loadTimedOut", userInfo: nil, repeats: false);
        
        setupUI()
    }
    
    func loadTimedOut() {
        self.terminate();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.center
        self.addSubview(activityIndicator)
        
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        self.alpha = 0.5
    }
    
    func terminate() {
        terminated = true
        if !didShow { return }
        UIView.animateWithDuration(0.25, animations: { _ in
            self.alpha = 0.0
            }, completion: { success in
                self.activityIndicator.stopAnimating()
                self.removeFromSuperview()
        })
    }
    
    
    func show() {
        didShow = true
        if !terminated {
            if let view = parentView {
                view.addSubview(self)
                return
            }
            UIApplication.sharedApplication().delegate!.window!?.addSubview(self)
        }
    }
    
    override func didMoveToSuperview() {
        activityIndicator.startAnimating()
        UIView.animateWithDuration(0.25) {
            self.alpha = 0.75
        }
    }
}
