//
//  CoreData.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/13/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import Foundation
import Contacts
import CoreData

let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

class CoreData {
    
    static let sharedInstance = CoreData()
    
    func addContact(contact:CNContact) {
        
        let entity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: managedContext)
        
        let coreDataContact = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        coreDataContact.setValue(contact.givenName, forKey: "givenName")
        
        coreDataContact.setValue(contact.familyName, forKey: "familyName")
        
        if let digits = contact.phoneNumbers.first?.value as? CNPhoneNumber {
            
            coreDataContact.setValue(digits.stringValue, forKey: "phoneNumber")
            
            do {
                try managedContext.save()
                print("saved \(contact.givenName)")
            } catch let error as NSError {
                print("managedContext error \(error)")
            }
            
        }
        
    }
    
    func fetchWithLocationID(locID:String) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest(entityName:"ViewedLocation")
        let predicate = NSPredicate(format: "locationID == %@", locID)
        fetchRequest.predicate = predicate
        
        if let fetchedResults = (try? managedContext.executeFetchRequest(fetchRequest)) as? [NSManagedObject] {
            return fetchedResults
        } else {
            return []
        }
        
    }
    
    func fetchContacts() -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest(entityName:"Contact")
        
        let sortDescriptor = NSSortDescriptor(key: "givenName", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
                
        do {
            if let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                return fetchedResults
            } else {
                return []
            }
        } catch let error as NSError {
            print("Could not fetch \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchFTContacts() -> [FTContact] {
        
        let array = fetchContacts()
        
        var returnArray = [FTContact]()
        
        for item in array {
            
            let givenName = item.valueForKey("givenName") as? String
            let familyName = item.valueForKey("familyName") as? String
            
            guard let phoneNumber = item.valueForKey("phoneNumber") as? String else {
                continue
            }
            
            let user = FTContact(givenName: givenName, familyName: familyName, phoneNumber: phoneNumber)
            
            if returnArray.contains(user) { continue }
            
            returnArray.append(user)
            
        }
        
        return returnArray
        
        
    }
    
    
}