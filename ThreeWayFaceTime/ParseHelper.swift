//
//  ParseHelper.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/14/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import Foundation
import Parse

class ParseHelper: NSObject {
    
    static let sharedInstance = ParseHelper()
    
    var calling:UserPhoneNumber?
    
    func createCall(session:OTSession) {
        
        if calling != nil {
            let username = PFUser.currentUser()!["phone"]
            
            let call = PFObject(className: "Call")
            call["initiator"] = username
            call["receiver"] = calling
            call["session"] = OpenTokHelper.sharedInstance.session.sessionId
            call["active"] = true
            
            call.saveInBackgroundWithBlock({ (result, error) -> Void in
                if error != nil {
                    UIAlertController().displayMessage(error!.localizedDescription)
                } else {
                    print("success")
                }
            })
            
        }
        
    }
    
}