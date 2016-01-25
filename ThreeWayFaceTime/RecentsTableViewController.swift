//
//  RecentsTableViewController.swift
//  ThreeWayFaceTime
//
//  Created by Hunter Maximillion Monk on 1/15/16.
//  Copyright © 2016 Hunter Maximillion Monk. All rights reserved.
//

import UIKit
import Parse

class RecentsTableViewController: UITableViewController {

    var recents = [PFObject]()
    
    let segmented = UISegmentedControl()
    
    var showOnlyMissed = false
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            RecentsHelper.sharedInstance.returnRecents(onlyMissed:false)
        } else {
            RecentsHelper.sharedInstance.returnRecents(onlyMissed:true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RecentsHelper.sharedInstance.delegate = self
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recents.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! RecentsTableViewCell
        
        let recent = recents[indexPath.row]
        
        if let missed = recent["missed"] as? Bool where missed == true {
            cell.numberLabel.textColor = UIColor.redColor()
        }
        
        if recent["initiator"] as! String == PFUser.currentUser()!.username! {
            cell.imageView?.image = UIImage(named: "InitiateCall")
        }
        
        if let receiver = recent["receiver"] as? String where receiver != PFUser.currentUser()?.username {
            cell.numberLabel.text = receiver
        }
        
        if let initiator = recent["receiver"] as? String where initiator != PFUser.currentUser()?.username {
            cell.numberLabel.text = initiator
        }
        
        cell.typeLabel.text = "mobile"
        
        cell.timeLabel.text = recent.createdAt?.returnString()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            recents.removeAtIndex(indexPath.row)
        }
    }


}

extension RecentsTableViewController: RecentsHelperDelegate {
    func displayRecents(calls: [PFObject]) {
        recents = calls
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
    }
}
