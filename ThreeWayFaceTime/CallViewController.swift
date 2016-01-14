//
//  MainViewController.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/2/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import UIKit
import Parse

class CallViewController: UIViewController {
    
    let screenSize = UIScreen.mainScreen().bounds
    
    // TODO: - Fix this lol
    class func instantiateFromStoryboard() -> CallViewController {
        return UIStoryboard(name: "Call", bundle: nil).instantiateInitialViewController() as! CallViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OpenTokHelper.sharedInstance.delegate = self
        
    }
    
}

extension CallViewController: OpenTokHelperDelegate {
    
    func displayPublisherView(publisher:OTPublisher) {
        publisher.view.frame = CGRectMake(0, 0, 200, 200)
        view.addSubview(publisher.view)
    }
    
    func displaySubscriberView(subscriber:OTSubscriber) {
        subscriber.view.frame = CGRectMake(0, 200, screenSize.width, 200)
        view.addSubview(subscriber.view)
    }
}








