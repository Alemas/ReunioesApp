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

    var participants:NSArray = []
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


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return colleagues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        let label = cell.viewWithTag(1) as! UILabel
        let name = ((colleagues[indexPath.row] as! PFObject)["realName"] as! String)
        label.text = name
        
        return cell
    }

}
