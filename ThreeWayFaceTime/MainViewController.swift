//
//  MainViewController.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/2/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // Replace with your OpenTok API key
    let apiKey = "45454712"
    // Replace with your generated session ID
    let sessionId = "2_MX40NTQ1NDcxMn5-MTQ1MTc5NDk2NjU1M35mcGkvWnpiVUJtZU1ySHVxU0pONjMxR1N-UH4"
    // Replace with your generated token
    let token = "T1==cGFydG5lcl9pZD00NTQ1NDcxMiZzaWc9MjIyZmVmZTRjZThiNzA2MDhiOTJlYTc3MjJhYTY2YTVlM2VlZWExNTpyb2xlPXB1Ymxpc2hlciZzZXNzaW9uX2lkPTJfTVg0ME5UUTFORGN4TW41LU1UUTFNVGM1TkRrMk5qVTFNMzVtY0drdlducGlWVUp0WlUxeVNIVnhVMHBPTmpNeFIxTi1VSDQmY3JlYXRlX3RpbWU9MTQ1MTc5NDk3MyZub25jZT0wLjI2MTA0OTQ3OTk0Nzc3MTA2JmV4cGlyZV90aW1lPTE0NTE4ODEzNTUmY29ubmVjdGlvbl9kYXRhPQ=="
    
    let screenSize = UIScreen.mainScreen().bounds
    
    var session:OTSession!
    var globalSubscriber:OTSubscriber!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = OTSession(apiKey: apiKey, sessionId: sessionId, delegate: self)
        
        connectSession()
    }
    
    func connectSession() {
        print("connectSession")
        var error:OTError? = nil
        
        
        session.connectWithToken(token, error: &error)
        
        
        if error != nil {
            print(error!.localizedDescription)
        }
        
    }
    
    func doPublish(session:OTSession) {
        print("doPublish")
        
        let publisher = OTPublisher(delegate: self, name: UIDevice.currentDevice().name)
            
        var error:OTError? = nil
        
        session.publish(publisher, error: &error)
        
        if error != nil {
            print(error?.localizedDescription)
        }
        
        view.addSubview(publisher.view)
        publisher.view.frame = CGRectMake(0, 0, 200, 200)
    }
    
    func doSubscribe(session:OTSession, stream:OTStream) {
        print("doSubscribe")
        globalSubscriber = OTSubscriber(stream: stream, delegate: self)
        
        var error:OTError? = nil
        
        session.subscribe(globalSubscriber, error: &error)
        
        if error != nil {
            print(error?.localizedDescription)
        }
    }

}

extension MainViewController: OTSessionDelegate {
    
    func sessionDidConnect(session: OTSession!) {
        print("sessionDidConnect")
        doPublish(session)
    }
    
    func session(session: OTSession!, streamCreated stream: OTStream!) {
        //doSubscribe(session, stream: stream)
        print("streamCreated")
    }
    
    func sessionDidDisconnect(session: OTSession!) {
        
    }
    
    func session(session: OTSession!, streamDestroyed stream: OTStream!) {
        print("streamDestroyed")
    }
    
    func session(session: OTSession!, didFailWithError error: OTError!) {
        print(error.localizedDescription)
    }
    
}

extension MainViewController: OTSubscriberKitDelegate {
    
    func subscriberDidConnectToStream(subscriber: OTSubscriberKit!) {
        print("subscriberDidConnectToStream")
        
        assert(subscriber == globalSubscriber)
        
        
        globalSubscriber.view.frame = CGRectMake(0, 200, screenSize.width, 200)
        view.addSubview(globalSubscriber.view)
        /*
        let actualSubscriber = OTSubscriber(stream: subscriber.stream, delegate: self)
        
        
        actualSubscriber.viewScaleBehavior = .Fit
        
        actualSubscriber.view.frame = CGRectMake(0, 200, screenSize.width, 200)
        
        view.addSubview(actualSubscriber.view)*/
    }
    
    func subscriber(subscriber: OTSubscriberKit!, didFailWithError error: OTError!) {
        print(error.localizedDescription)
    }
    
    
}

extension MainViewController: OTPublisherDelegate {
    
    func publisher(publisher: OTPublisherKit!, streamCreated stream: OTStream!) {
        doSubscribe(publisher.session, stream: stream)
    }
    
    func publisher(publisher: OTPublisherKit!, didFailWithError error: OTError!) {
        print(error.localizedDescription)
    }
    
    
}








