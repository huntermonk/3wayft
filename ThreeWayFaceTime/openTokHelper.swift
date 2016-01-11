//
//  openTokHelper.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/11/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import Foundation
import Parse


protocol openTokHelperDelegate {

    func displayPublisherView(publisher:OTPublisher)
    func displaySubscriberView(subscriber:OTSubscriber)
}


public class openTokHelper : NSObject {
    
    let key = "45454712"
    
    var delegate:openTokHelperDelegate?
    
    var id:String?
    
    var token:String?
    
    var session:OTSession!
    var globalSubscriber:OTSubscriber!
    
    static let sharedInstance = openTokHelper()
    
    override public init() {
        super.init()
        if let cacheSession = PFUser.currentUser()?["session"] as? String {
            session = OTSession(apiKey: key, sessionId: cacheSession, delegate: self)
            generateToken(cacheSession)
        } else {
            createSession()
        }
    }
    
    private func createSession() {
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
    
    
    private func generateToken(sessionId:String) {
        
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
    
    private func connectSession() {
        
        print("connectSession")
        var error:OTError? = nil
        
        if token != nil {
            session.connectWithToken(token, error: &error)
        }
        
        if error != nil {
            print(error!.localizedDescription)
        }
        
    }
    
    private func doPublish(session:OTSession) {
        print("doPublish")
        
        let publisher = OTPublisher(delegate: self, name: UIDevice.currentDevice().name)
        
        var error:OTError? = nil
        
        session.publish(publisher, error: &error)
        
        if error != nil {
            print(error?.localizedDescription)
        }
        
        delegate?.displayPublisherView(publisher)
        
        
    }
    
    private func doSubscribe(session:OTSession, stream:OTStream) {
        print("doSubscribe")
        globalSubscriber = OTSubscriber(stream: stream, delegate: self)
        
        var error:OTError? = nil
        
        session.subscribe(globalSubscriber, error: &error)
        
        if error != nil {
            print(error?.localizedDescription)
        }
        
    }

}

extension openTokHelper: OTSessionDelegate {
    
    public func sessionDidConnect(session: OTSession!) {
        print("sessionDidConnect")
        doPublish(session)
    }
    
    public func session(session: OTSession!, streamCreated stream: OTStream!) {
        doSubscribe(session, stream: stream)
        print("streamCreated")
    }
    
    public func sessionDidDisconnect(session: OTSession!) {
        
    }
    
    public func session(session: OTSession!, streamDestroyed stream: OTStream!) {
        print("streamDestroyed")
    }
    
    public func session(session: OTSession!, didFailWithError error: OTError!) {
        print(error.localizedDescription)
    }
    
}

extension openTokHelper: OTSubscriberKitDelegate {
    
    public func subscriberDidConnectToStream(subscriber: OTSubscriberKit!) {
        print("subscriberDidConnectToStream")
        
        delegate?.displaySubscriberView(globalSubscriber)
        
    }
    
    public func subscriber(subscriber: OTSubscriberKit!, didFailWithError error: OTError!) {
        print(error.localizedDescription)
    }
    
}

extension openTokHelper: OTPublisherDelegate {
    
    public func publisher(publisher: OTPublisherKit!, streamCreated stream: OTStream!) {
        doSubscribe(publisher.session, stream: stream)
        
    }
    
    public func publisher(publisher: OTPublisherKit!, didFailWithError error: OTError!) {
        print(error.localizedDescription)
    }
    
    
}