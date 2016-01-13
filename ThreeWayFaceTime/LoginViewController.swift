//
//  LoginViewController.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/11/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import UIKit
import DigitsKit
import Parse

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addDigitsButton()
        
    }
    
    func addDigitsButton() {
        
        let digitsButton = DGTAuthenticateButton(authenticationCompletion: {
            (session, error) in
            // Inspect session/error objects
            if error != nil {
                print("error \(error)")
            } else {
                self.loginParse(session)
            }
            
        })
        
        digitsButton.center = view.center
        self.view.addSubview(digitsButton)
        
    }
    
    func loginParse(digitsSession:DGTSession) {
        
        PFUser.becomeInBackground(digitsSession.authToken) {
            (user, error) -> Void in
            if error != nil {
                print(error)
            } else {
                self.presentViewController(MainViewController.instantiateFromStoryboard(), animated: true, completion: { () -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
        
    }

}
