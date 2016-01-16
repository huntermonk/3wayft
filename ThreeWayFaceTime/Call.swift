//
//  Call.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/15/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import Foundation

class Call:NSObject {
    
    var calling: UserPhoneNumber?
    convenience override init() {
        self.init(calling: nil)
    }
    
    init(calling: UserPhoneNumber?) {
        self.calling = calling
        super.init()
        
        let window = UIWindow()
        window.rootViewController = CallViewController(calling: calling)
        window.makeKeyAndVisible()
    }
    
}