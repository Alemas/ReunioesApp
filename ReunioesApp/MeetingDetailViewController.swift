//
//  MeetingDetailViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/12/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit

class MeetingDetailViewController: UIViewController {

    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTolerance: UILabel!
    @IBOutlet weak var txvExtraInfo: UITextView!
    @IBOutlet weak var btnEmmitSignal: UIButton!
    
    var meeting:Meeting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblSubject.text = meeting!.subject
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MMM/dd/yyyy hh:mm a"
        let date = formatter.stringFromDate(meeting!.date)
        self.lblDate.text = date
        
        self.lblAddress.text = meeting!.address
        self.lblTolerance.text = "\(self.meeting!.tolerance) min"
        self.txvExtraInfo.text = meeting!.extraInfo
        
        btnEmmitSignal.hidden = true

        if meeting!.creator == User.getCurrentUser() {
            btnEmmitSignal.hidden = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didPressEmmitSignal(sender: AnyObject) {
        
    }


}
