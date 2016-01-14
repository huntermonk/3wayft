//
//  MainViewController.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/2/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController {
    
    let screenSize = UIScreen.mainScreen().bounds
    
    class func instantiateFromStoryboard() -> MainViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("") as! MainViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OpenTokHelper.sharedInstance.delegate = self
        /*
        let second = secondStream(frame: CGRectMake(0,400,screenSize.width,200))
        second.backgroundColor = UIColor.redColor()
        
        view.addSubview(second)*/
        
    }

}

extension MainViewController: OpenTokHelperDelegate {
    
    func displayPublisherView(publisher:OTPublisher) {
        publisher.view.frame = CGRectMake(0, 0, 200, 200)
        view.addSubview(publisher.view)
    }
    
    func displaySubscriberView(subscriber:OTSubscriber) {
        subscriber.view.frame = CGRectMake(0, 200, screenSize.width, 200)
        view.addSubview(subscriber.view)
    }
}








