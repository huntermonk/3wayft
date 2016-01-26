//
//  DigitsHelper.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/14/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import Foundation
import DigitsKit

protocol DigitsHelperDelegate {
    func displayMatches(matches:[DGTUser])
}

public class DigitsHelper : NSObject {
    
    var delegate:DigitsHelperDelegate?
    
    static let sharedInstance = DigitsHelper()
    
    var matchedContacts = [DGTUser]()
    
    override init() {
        super.init()
        retrieveMatches()
        uploadContacts()
    }
    
    func retrieveMatches() {
        self.matchedContacts = [DGTUser]()
        retrieveContactsWithCursor(nil)
    }
    
    func retrieveContactsWithCursor(cursor:String?) {
        
        let userSession = Digits.sharedInstance().session()
        let contacts = DGTContacts(userSession: userSession)
        
        contacts.lookupContactMatchesWithCursor(cursor) { matches, nextCursor, error in
            UIAlertController().displayError(error)
            
            if let array = matches as? [DGTUser] {
                self.update(array)
            }
            
            if nextCursor != nil {
                self.retrieveContactsWithCursor(nextCursor!)
            }
        }
    }
    
    func update(matches:[DGTUser]) {
        matchedContacts += matches
        delegate?.displayMatches(matchedContacts)
    }
    
    func uploadContacts() {
        let userSession = Digits.sharedInstance().session()
        let contacts = DGTContacts(userSession: userSession)
        
        contacts.startContactsUploadWithCompletion {
            result, error in
            if error != nil {
                print("error \(error.debugDescription)")
            }
        }
    }

}