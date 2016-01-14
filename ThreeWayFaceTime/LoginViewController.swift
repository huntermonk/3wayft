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
import Contacts

class LoginViewController: UIViewController {
    
    class func instantiateFromStoryboard() -> LoginViewController {
        return UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as! LoginViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addDigitsButton()
    }
    
    func addDigitsButton() {
        
        let digitsButton = DGTAuthenticateButton(authenticationCompletion: {
            (session, error) in
            // Inspect session/error objects
            if error != nil {
                print("error \(error)")
                UIAlertController().displayMessage(error!.localizedDescription)
            } else {
                self.loginParse()
            }
            
        })
                
        digitsButton.center = view.center
        self.view.addSubview(digitsButton)
        
    }
    
    func loginParse() {
        
        PFUser.loginWithDigitsInBackground({ (user, error) -> Void in
            if error != nil {
                UIAlertController().displayMessage(error!.localizedDescription)
            } else {
                self.uploadContacts()
            }
        })
        
    }
    
    func dismiss() {
        
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() {
            presentViewController(controller, animated: true) { () -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    
    // TODO: - Get all this logic out to the model

    func uploadContacts() {
        let userSession = Digits.sharedInstance().session()
        let contacts = DGTContacts(userSession: userSession)
        
        contacts.startContactsUploadWithCompletion {
            result, error in
            
            if error != nil {
                print("error \(error)")
                if error.code != 8 {
                    UIAlertController().displayMessage(error!.localizedDescription)
                } else {
                    self.dismiss()
                }
            } else {
                self.dismiss()
            }
        }
    }
    
    func searchContacts() {
        let userSession = Digits.sharedInstance().session()
        let contacts = DGTContacts(userSession: userSession)
        
        contacts.lookupContactMatchesWithCursor(nil) { matches, nextCursor, error in
            // matches is an Array of DGTUser objects.
            // Use nextCursor in a follow-up call to this method to offset the results.
            print(matches)
            print(error)
        }
    }

}
