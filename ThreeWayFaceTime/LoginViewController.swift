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
        
        let user = PFUser()
        user.username = digitsSession.phoneNumber
        user.password = digitsSession.userID
        
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            if error != nil {
                print("signupError \(error)")
                
                if error!.code == 202 {
                    PFUser.logInWithUsernameInBackground(digitsSession.phoneNumber, password: digitsSession.userID, block: { (user, error) -> Void in
                        //self.uploadContacts()
                        self.searchContacts()
                    })
                }
                //self.uploadContacts()
            } else {
                print("sexcess")
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
        
        print("contacts count \(i)")
    }
    
    override func viewDidAppear(animated: Bool) {
        print("contacts count \(CoreData.sharedInstance.fetchAllContacts().count)")
    }
    
    func uploadContacts() {
        let userSession = Digits.sharedInstance().session()
        print(userSession)
        let contacts = DGTContacts(userSession: userSession)
        
        contacts.startContactsUploadWithCompletion {
            result, error in
            // Inspect results and error objects to determine if upload succeeded.
            print("error\(error)")
            print("result contacts\(result.totalContacts)")
            print("result contacts successful\(result.numberOfUploadedContacts)")
            
        }
    }
    
    func searchContacts() {
        // Swift
        let userSession = Digits.sharedInstance().session()
        let contacts = DGTContacts(userSession: userSession)
        
        /*
        contacts.lookupContactMatchesWithCursor(nil) { matches, nextCursor, error in
            // matches is an Array of DGTUser objects.
            // Use nextCursor in a follow-up call to this method to offset the results.
            print(matches)
            print(error)
        }*/
    }

}
