//
//  ContactTableViewController.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/13/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import UIKit
import ContactsUI
import DigitsKit


class ContactTableViewController: UITableViewController {
    
    //var contacts:[FTContact] = []
    var contacts:[DGTUser] = []
    
    let screenSize = UIScreen.mainScreen().bounds
    
    class func instantiateFromStoryboard() -> ContactTableViewController {
        return UIStoryboard(name: "Contact", bundle: nil).instantiateInitialViewController() as! ContactTableViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DigitsHelper.sharedInstance.delegate = self
        //contacts = CoreData.sharedInstance.fetchFTContacts()
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        let match = contacts[indexPath.row]
        //cell.textLabel?.text = match.givenName! + " " + match.familyName!
        cell.textLabel?.text = match.userID
        /*
        if contacts.count != 0 {
            let contact = contacts[indexPath.row]
            cell.textLabel?.text = "\(contact.givenName!) \(contact.familyName!)"
        }*/

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //let phone = contacts[indexPath.row].phoneNumber
        let phone = "+18179144411"
        
        let controller = CallViewController.init(calling: phone)
        controller.modalTransitionStyle = .CrossDissolve
        presentViewController(controller, animated: true, completion: nil)
        
    }

}

extension ContactTableViewController: CNContactPickerDelegate {
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        print("selected property \(contactProperty)")
    }
    
}

extension ContactTableViewController: DigitsHelperDelegate {
    func displayMatches(matches: [DGTUser]) {
        contacts = matches
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
    }
}
