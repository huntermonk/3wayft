//
//  FT+NSUserDefaults.swift
//  Walk-In-Lobby
//
//  Created by Hunter Maximillion Monk on 10/14/15.
//  Copyright © 2015 Hunter Maximillion Monk. All rights reserved.
//

import Foundation

extension NSUserDefaults {
    
    func savePurchasedTransaction(transaction:SKPaymentTransaction) {
        let identifier = transaction.payment.productIdentifier
        savePurchasedItem(identifier)
    }
    
    func savePurchasedItem(productIdentifier:String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(true, forKey: productIdentifier)
        userDefaults.synchronize()
    }
    
    func setStereoscopicMode(stereo:Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(stereo, forKey: "stereo")
        userDefaults.synchronize()
    }
    
    func returnStereoMode() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.boolForKey("stereo")
    }
    
}