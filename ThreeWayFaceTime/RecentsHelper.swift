//
//  RecentsHelper.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/15/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import Foundation
import Parse

protocol RecentsHelperDelegate {
    func displayRecents(calls:[PFObject])
}

class RecentsHelper: NSObject {
    
    var delegate:RecentsHelperDelegate?
    
    static let sharedInstance = RecentsHelper()
    
    var recents = [PFObject]()
    
    override init() {
        super.init()
        retrieveRecents()
    }
    
    func retrieveRecents() {
        let initiated = PFQuery(className:"Call")
        initiated.whereKey("initiator", equalTo: PFUser.currentUser()!.username!)
        
        let received = PFQuery(className: "Call")
        received.whereKey("receiver", equalTo: PFUser.currentUser()!.username!)
        
        let combined = PFQuery.orQueryWithSubqueries([initiated, received])
        combined.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            UIAlertController().displayError(error)
            if results != nil {
                self.recents = results!
                self.delegate?.displayRecents(self.recents)
            }
        }
    }
}