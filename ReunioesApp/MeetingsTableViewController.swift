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
        return meetings.count
    }
    @IBAction func didPressBack(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindFromMeetings", sender: nil)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let subjectlabel = cell.viewWithTag(1) as! UILabel
        let dateLabel = cell.viewWithTag(2) as! UILabel
        
        let meeting = self.meetings[indexPath.row] as! Meeting
        if (meeting.creator == User.getCurrentUser()) {
            subjectlabel.text = "[Creator] \(meeting.subject)"
        } else {
            subjectlabel.text = meeting.subject
        }
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MMM/dd/yyyy hh:mm a"
        let date = formatter.stringFromDate(meeting.date)
        dateLabel.text = date

        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMeetingDetail" {
            let index = (sender as! NSIndexPath).row
            (segue.destinationViewController as! MeetingDetailViewController).meeting = self.meetings[index] as! Meeting
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("showMeetingDetail", sender: indexPath)
        
    }





}
