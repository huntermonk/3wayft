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
        // Do any additional setup after loading the view.
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
                print("PFUSer \(user)")
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
    
    func uploadAllContacts() {
        let store = CNContactStore()
        
        var i = 0
        do {
            let request = CNContactFetchRequest(keysToFetch: [CNContactPhoneNumbersKey,CNContactGivenNameKey,CNContactFamilyNameKey])
            try store.enumerateContactsWithFetchRequest(request, usingBlock: {
                (contact, error) -> Void in
                ++i
                CoreData.sharedInstance.addContact(contact)
            })
            
        } catch {
            print("error")
        }
        
    }

    // TODO: - Figure out why I'm always getting Error Domain=DigitsErrorDomain Code=8
    func uploadContacts() {
        let userSession = Digits.sharedInstance().session()
        let contacts = DGTContacts(userSession: userSession)
        
        contacts.startContactsUploadWithCompletion {
            result, error in
            // Inspect results and error objects to determine if upload succeeded.
            
            if error != nil {
                print("error \(error)")
                UIAlertController().displayMessage(error!.localizedDescription)
            }
            
            self.dismiss()
            self.uploadAllContacts()
            
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
