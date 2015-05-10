//
//  NewMeetingViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/9/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit

class NewMeetingViewController: UIViewController {

    @IBOutlet weak var txfTolerance: UITextField!
    @IBOutlet weak var txfDate: UITextField!
    @IBOutlet weak var txfSubject: UITextField!
    @IBOutlet weak var txvAddress: UITextView!
    
    var didCreateNewMeeting = false
    var participants = [User.getCurrentUser()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txvAddress.layer.borderWidth = 1.0
        self.txvAddress.layer.borderColor = UIColor.lightGrayColor().CGColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func validFields() -> Bool {
        
        if self.txfSubject.text != "" && self.txfDate.text != "" && txfTolerance != "" &&
            self.txvAddress.text != "" && self.participants.count>1 {
                return true
        }
        return false
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    
    @IBAction func unwindFromSelectParticipants(segue:UIStoryboardSegue) {
        
        
        
    }
    
    @IBAction func didPressSelectParticipants(sender: UIButton) {
        
        self.performSegueWithIdentifier("showSelectParticipants", sender: nil)
        
    }

    @IBAction func didPressCreateMeeting(sender: UIButton) {
        
        if !validFields() {
            var alert = UIAlertView(title: "Error", message: "Invalid Parameters", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
            return
        }
        
    }

    @IBAction func didPressCancel(sender: UIButton) {
        self.performSegueWithIdentifier("unwindFromNewMeeting", sender: nil)
    }
    
    
}
