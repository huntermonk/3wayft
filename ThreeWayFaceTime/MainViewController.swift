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
    
    let key = "45454712"
    
    var id:String?
    
    var token:String?
    
    let screenSize = UIScreen.mainScreen().bounds
    
    var session:OTSession!
    var globalSubscriber:OTSubscriber!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cacheSession = PFUser.currentUser()?["session"] as? String {
            session = OTSession(apiKey: key, sessionId: cacheSession, delegate: self)
            generateToken(cacheSession)
        } else {
            createSession()
        }
        
        
        /*
        let second = secondStream(frame: CGRectMake(0,400,screenSize.width,200))
        second.backgroundColor = UIColor.redColor()
        
        view.addSubview(second)*/
        
    }
    
    func createSession() {
        print("createSession()")
        
        PFCloud.callFunctionInBackground("opentokNewSession", withParameters: nil) {
            (sessionID, error) -> Void in
            if error != nil {
                print("error \(error)")
            } else if let id = sessionID as? String {
                self.session = OTSession(apiKey: self.key, sessionId: id, delegate: self)
                self.generateToken(id)
            }
        }
        
    }
    
    
    func generateToken(sessionId:String) {
        
        PFCloud.callFunctionInBackground("opentokGenerateToken", withParameters: ["sessionId":"\(sessionId)"]) { (result, error) -> Void in
            if error != nil {
                print("error \(error)")
            } else if let id = result as? String {
                self.token = id
                self.connectSession()
                self.updateUserSession(sessionId)
            }
        }
        
    }
    
    func updateUserSession(sessionID:String) {
        
        let user = PFUser.currentUser()
        user!["session"] = sessionID
        user!.saveInBackground()
        
    }
    
    func connectSession() {
        
        print("connectSession")
        var error:OTError? = nil
        
        if token != nil {
            session.connectWithToken(token, error: &error)
        }
        
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
        doSubscribe(session, stream: stream)
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
        
        globalSubscriber.view.frame = CGRectMake(0, 200, screenSize.width, 200)
        view.addSubview(globalSubscriber.view)
        
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








