//
//  WL+UIAlertController.swift
//  walk-in-cardboard
//
//  Created by Hunter Maximillion Monk on 12/23/15.
//  Copyright © 2015 MONKEYmedia, Inc. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    func displayMessage(message:String) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        
        let window = UIApplication.sharedApplication().windows[0]
        
        window.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}