//
//  MainViewController.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/2/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import UIKit
import Parse

public typealias UserPhoneNumber = String

class CallViewController: UIViewController {
    
    let screenSize = UIScreen.mainScreen().bounds
    var calling: UserPhoneNumber?
    
    class func instantiateFromStoryboard() -> CallViewController {
        return UIStoryboard(name: "Call", bundle: nil).instantiateInitialViewController() as! CallViewController
    }
    
    // this is a convenient way to create this view controller without a calling
    convenience init() {
        self.init(calling: nil)
    }
    
    init(calling: UserPhoneNumber?) {
        self.calling = calling
        super.init(nibName: nil, bundle: nil)
        ParseHelper.sharedInstance.calling = calling
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OpenTokHelper.sharedInstance.delegate = self
    }
    
    var newSubscriberY:CGFloat = 0
    
}

extension CallViewController: OpenTokHelperDelegate {
    
    func displayPublisherView(publisher:OTPublisher) {
        publisher.view.frame = view.frame
        view.addSubview(publisher.view)
    }
    
    func displaySubscriberView(subscriber:OTSubscriber) {
        subscriber.view.frame = CGRectMake(0, newSubscriberY, screenSize.width, 200)
        view.addSubview(subscriber.view)
        newSubscriberY += 200
    }
}








