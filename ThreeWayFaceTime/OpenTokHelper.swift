//
//  OpenTokHelper.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/11/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import Foundation
import Parse

protocol OpenTokHelperDelegate {
    
    func displayPublisherView(publisher:OTPublisher)
    func displaySubscriberView(subscriber:OTSubscriber)
}

/*

public typealias LoginCompletionBlock = ((PFUser?, NSError?) -> Void)
public typealias LinkCompletionBlock = ((Bool, NSError?) -> Void)

//___ This is how you make variables that always equal that lol
private struct Constants {
static let sessionKey = "session"
static let requestURLStringKey = "requestURLString"
static let authorizationHeaderKey = "authorizationHeader"
}

*/

public class OpenTokHelper : NSObject {
    
    let key = "45454712"
    
    var delegate:OpenTokHelperDelegate?
    
    var session:OTSession!
    var globalSubscriber:OTSubscriber!
    
    static let sharedInstance = OpenTokHelper()
    
    override public init() {
        super.init()
        
        if let cachedSession = PFUser.currentUser()?["session"] as? String {
            session = OTSession(apiKey: key, sessionId: cachedSession, delegate: self)
            generateToken(cachedSession)
        } //else {
            //createSession()
        //}
        
        else {
            let id = "2_MX40NTQ1NDcxMn5-MTQ1MjgwMzQwOTE1Mn5RdlhvVkwvaE5HSUdtSXdPRTdza3FpWTl-fg"
            session = OTSession(apiKey: key, sessionId: id, delegate: self)
            generateToken(id)
        }
        
    }
    
    private func createSession() {
        
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
            } else if let token = result as? String {
                self.connectSession(token)
                self.updateUserSession(sessionId)
            }
        }
        
    }
    
    func updateUserSession(sessionID:String) {
        
        if let user = PFUser.currentUser() {
            user["session"] = sessionID
            user.saveInBackground()
        }
        
    }
    
    private func connectSession(token:String) {
        
        var error:OTError? = nil
        
        session.connectWithToken(token, error: &error)
        
        if error != nil {
            print(error!.localizedDescription)
        }
        
    }
    
    private func doPublish(session:OTSession) {
        
        let publisher = OTPublisher(delegate: self, name: UIDevice.currentDevice().name)
        
        var error:OTError? = nil
        
        session.publish(publisher, error: &error)
        
        if error != nil {
            print(error?.localizedDescription)
        }
        
        delegate?.displayPublisherView(publisher)
        
    }
    
    private func doSubscribe(session:OTSession, stream:OTStream) {

        globalSubscriber = OTSubscriber(stream: stream, delegate: self)
        
        var error:OTError? = nil
        
        session.subscribe(globalSubscriber, error: &error)
        
        if error != nil {
            print(error?.localizedDescription)
        }
        
    }
    
}

extension OpenTokHelper: OTSessionDelegate {
    
    public func sessionDidConnect(session: OTSession!) {
        print("sessionDidConnect")
        doPublish(session)
    }
    
    public func session(session: OTSession!, streamCreated stream: OTStream!) {
        print("session streamCreated")
        if stream.connection.connectionId != session.connection.connectionId {
            //___ This is a stream from somebody else, not me lol
            doSubscribe(session, stream: stream)
        } else {
            print(stream.connection.connectionId)
            print(session.connection.connectionId)
            print("this is my stream")
        }
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

extension OpenTokHelper: OTSubscriberKitDelegate {
    
    public func subscriberDidConnectToStream(subscriber: OTSubscriberKit!) {
        print("subscriberDidConnectToStream")
        delegate?.displaySubscriberView(globalSubscriber)
        
    }
    
    public func subscriber(subscriber: OTSubscriberKit!, didFailWithError error: OTError!) {
        print(error.localizedDescription)
    }
    
}

extension OpenTokHelper: OTPublisherDelegate {
    
    public func publisher(publisher: OTPublisherKit!, streamCreated stream: OTStream!) {
        print("publisher streamCreated")
    }
    
    public func publisher(publisher: OTPublisherKit!, didFailWithError error: OTError!) {
        print(error.localizedDescription)
    }
    
    
}