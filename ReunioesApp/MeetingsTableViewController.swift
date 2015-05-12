//
//  MeetingsTableViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/12/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit

class MeetingsTableViewController: UITableViewController {

    var meetings = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.meetings = User.getMeetings()
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings.count
    }
    @IBAction func didPressBack(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindFromMeetings", sender: nil)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        let meeting = self.meetings[indexPath.row] as! Meeting
        cell.detailTextLabel?.text = meeting.subject
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MMM/dd/yyyy hh:mm a"
        let date = formatter.stringFromDate(meeting.date)
        cell.textLabel?.text = date

        return cell
    }







}
