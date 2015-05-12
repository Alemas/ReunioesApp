//
//  SelectParticipantsTableViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/10/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit
import Parse
import Bolts

class SelectParticipantsTableViewController: UITableViewController {

    var participants:NSMutableArray?
    var colleagues:NSArray = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.colleagues = User.getColleagues()
            
            dispatch_async(dispatch_get_main_queue()) { self.tableView.reloadData() }

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didPressBack(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindFromSelectParticipants", sender: nil)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return colleagues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let colleague = (colleagues[indexPath.row] as! PFObject)
        
        let label = cell.viewWithTag(1) as! UILabel
        let name = (colleague["realName"] as! String)
        label.text = name
        
        let imv = cell.viewWithTag(2) as! UIImageView
        imv.image = UIImage(named: "unchecked")
        if self.participants!.containsObject(colleague){
            imv.image = UIImage(named: "checked")
            if colleague == User.getCurrentUser(){
                imv.image = UIImage(named: "checkmark")
            }
        }
                
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        let colleague = self.colleagues[indexPath.row] as! PFObject
        let imv = cell?.viewWithTag(2) as! UIImageView
        
        if colleague == User.getCurrentUser() {
            imv.image = UIImage(named: "checkmark")
            return
        }
        
        if self.participants!.containsObject(colleague) {
            self.participants!.removeObject(colleague)
            imv.image = UIImage(named: "unchecked")
        } else {
            self.participants!.addObject(colleague)
            imv.image = UIImage(named: "checked")
        }
        
    }

}
