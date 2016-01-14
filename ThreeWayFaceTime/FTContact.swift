//
//  FTContact.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/13/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import Foundation

class FTContact: NSObject {
    
    let givenName:String?
    let familyName:String?
    let phoneNumber:String
    
    init(givenName:String?,familyName:String?,phoneNumber:String) {
        self.givenName = givenName
        self.familyName = familyName
        self.phoneNumber = phoneNumber
        super.init()
    }
    
    
    
}