//
//  secondStream.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/8/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import Foundation

class secondStream: UIView {
    
    let key = "45461132"
    let id = "1_MX40NTQ2MTEzMn5-MTQ1MjMxODEyNTUzOH5hL0VnRkI1aytMYjBZV0EyTFFuNEpxM3R-UH4"
    let token = "T1==cGFydG5lcl9pZD00NTQ2MTEzMiZzaWc9YTQ2NzM0OGNjMWI3NzY5MDBhMDQzMzVjYWYwMWRlMGM5ZjAxZmE0Mzpyb2xlPXB1Ymxpc2hlciZzZXNzaW9uX2lkPTFfTVg0ME5UUTJNVEV6TW41LU1UUTFNak14T0RFeU5UVXpPSDVoTDBWblJrSTFheXRNWWpCWlYwRXlURkZ1TkVweE0zUi1VSDQmY3JlYXRlX3RpbWU9MTQ1MjMxODE1MSZub25jZT0wLjU5NTA1MzkwOTUzNzc0MDQmZXhwaXJlX3RpbWU9MTQ1NDkxMDEyMSZjb25uZWN0aW9uX2RhdGE9"
    
    var session:OTSession!
    var globalSubscriber:OTSubscriber!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        session = OTSession(apiKey: key, sessionId: id, delegate: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        session = OTSession(apiKey: key, sessionId: id, delegate: self)
        connectSession()
    }
    
    func connectSession() {
        print("2connectSession")
        var error:OTError? = nil
        
        session.connectWithToken(token, error: &error)
        
        
        if error != nil {
            print(error!.localizedDescription)
        }
        
    }
    /*
    func doPublish(session:OTSession) {
        print("2doPublish")
        
        let publisher = OTPublisher(delegate: self, name: UIDevice.currentDevice().name)
        
        var error:OTError? = nil
        
        session.publish(publisher, error: &error)
        
        if error != nil {
            print(error?.localizedDescription)
        }
        
        addSubview(publisher.view)
        publisher.view.frame = CGRectMake(0, 0, 50, 50)
    }*/
    
    func doSubscribe(session:OTSession, stream:OTStream) {
        print("2doSubscribe")
        globalSubscriber = OTSubscriber(stream: stream, delegate: self)
        
        var error:OTError? = nil
        session.subscribe(globalSubscriber, error: &error)
        
        if error != nil {
            print(error?.localizedDescription)
        }
        
    }
    
}

extension secondStream: OTSessionDelegate {
    
    func sessionDidConnect(session: OTSession!) {
    }
    
    func sessionDidDisconnect(session: OTSession!) {
        
    }
    
    func session(session: OTSession!, streamCreated stream: OTStream!) {
        print("2StreamCreated")
        doSubscribe(session, stream: stream)
    }
    
    func session(session: OTSession!, streamDestroyed stream: OTStream!) {
    }
    
    func session(session: OTSession!, didFailWithError error: OTError!) {
    }
    
}

extension secondStream: OTSubscriberKitDelegate {
    
    func subscriberDidConnectToStream(subscriber: OTSubscriberKit!) {
        print("2subscriberDidConnectToStream")
        globalSubscriber.view.frame = CGRectMake(50, 0, 100, 200)
        addSubview(globalSubscriber.view)
    }
    
    func subscriber(subscriber: OTSubscriberKit!, didFailWithError error: OTError!) {
        
    }
}
/*
extension secondStream: OTPublisherDelegate {
    
    func publisher(publisher: OTPublisherKit!, streamCreated stream: OTStream!) {
        doSubscribe(publisher.session, stream: stream)
        
    }
    
    func publisher(publisher: OTPublisherKit!, didFailWithError error: OTError!) {
        print(error.localizedDescription)
    }
    
    
}*/