//
//  ContactTableViewController.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/13/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import UIKit
import ContactsUI

class ContactTableViewController: UITableViewController {
    
    var contacts:[FTContact] = []
    
    let screenSize = UIScreen.mainScreen().bounds
    
    class func instantiateFromStoryboard() -> ContactTableViewController {
        return UIStoryboard(name: "Contact", bundle: nil).instantiateInitialViewController() as! ContactTableViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = CoreData.sharedInstance.fetchFTContacts()
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        if contacts.count != 0 {
            let contact = contacts[indexPath.row]
            cell.textLabel?.text = "\(contact.givenName!) \(contact.familyName!)"
        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let phone = contacts[indexPath.row].phoneNumber
        
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
