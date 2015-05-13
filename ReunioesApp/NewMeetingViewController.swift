//
//  NewMeetingViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/9/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit
import MapKit
import Parse

class NewMeetingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var txfTolerance: UITextField!
    @IBOutlet weak var txfDate: UITextField!
    @IBOutlet weak var txfSubject: UITextField!
    @IBOutlet weak var txfAddress: UITextField!
    @IBOutlet weak var txvExtraInfo: UITextView!
    
    var participants = NSMutableArray(array: [User.getCurrentUser()!])
    var toleranceValues = NSMutableArray()
    var tolerance = 0
    var address = ""
    var coordinate = NSMutableArray()
    var date:NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txvExtraInfo.layer.borderColor = (UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)).CGColor
        self.txvExtraInfo.layer.borderWidth = 1.0
        
        var datePicker = UIDatePicker()
        self.txfDate.inputView = datePicker
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.minimumDate = NSDate()
        datePicker.addTarget(self, action: Selector("didChangeDatePickerValue:"), forControlEvents: UIControlEvents.ValueChanged)
        
        var tolerancePicker = UIPickerView()
        self.txfTolerance.inputView = tolerancePicker
        tolerancePicker.dataSource = self
        tolerancePicker.delegate = self
        
        for i in 1...12 {
            self.toleranceValues.addObject(i*5)
        }
        
        tolerancePicker.backgroundColor = UIColor.whiteColor()
        
        self.txfAddress.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.txfAddress.text = self.address
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func validFields() -> Bool {
        
        if self.txfSubject.text != "" && self.date != nil && self.txfTolerance != "" &&
            self.txfAddress.text != "" && self.participants.count>1 && self.coordinate != [] {
                return true
        }
        return false
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier=="showSelectParticipants" {
            var vc = (segue.destinationViewController as!UINavigationController).childViewControllers[0] as! SelectParticipantsTableViewController
            vc.participants = self.participants
        }
        
        if segue.identifier=="showSetAddress" {
            var vc = (segue.destinationViewController as!UINavigationController).childViewControllers[0] as! SetAddressViewController
            vc.coordinate = self.coordinate
        }
        
    }
    
    @IBAction func unwindFromSelectParticipants(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromSetAddress(segue:UIStoryboardSegue) {
        self.address = segue.sourceViewController.address
    }
    
    func didChangeDatePickerValue(sender:UIDatePicker) {
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MMM/dd/yyyy hh:mm a"
        let date = formatter.stringFromDate(sender.date)
        self.txfDate.text = date
        self.date = sender.date
        
    }
    
    @IBAction func handleAddressTap(sender: AnyObject) {
        self.performSegueWithIdentifier("showSetAddress", sender: nil)
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
        
        let minor = Int(arc4random_uniform(65537))
        let major = Int(arc4random_uniform(65537))
        
        let meeting = Meeting(subject: txfSubject.text, creator: User.getCurrentUser()!, participants: participants, address: txfAddress.text, date: date!, tolerance: tolerance, minorAndMajor: [minor, major], coordinate: coordinate, extraInfo: txvExtraInfo.text)
        
        let closure = {(succeeded:Bool) -> Void in
        
            if (succeeded) {
                self.sendPush()
                self.performSegueWithIdentifier("unwindFromNewMeeting", sender: nil)
            } else {
                var alert = UIAlertView(title: "Error", message: "There was an error trying to create the meeting", delegate: nil, cancelButtonTitle: "Ok")
            }
        
        }
        
        User.newMeeting(meeting, closure: closure)
        
    }

    @IBAction func didPressCancel(sender: UIButton) {
        self.performSegueWithIdentifier("unwindFromNewMeeting", sender: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return toleranceValues.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(self.toleranceValues[row] as! Int) min"
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txfTolerance.text = "\(self.toleranceValues[row] as! Int) min"
        self.tolerance = self.toleranceValues[row] as! Int
    }
    
    @IBAction func didEndEditing(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func sendPush() -> Void{
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value),0))
        {
            let creator = User.getCurrentUser()!["realName"] as! String
            
            for(var i = 0 ; i < self.participants.count ; i++){
                
                var pfObject:PFObject = self.participants[i] as! PFObject
                
                let participantId = pfObject.objectId
                let creatorId = User.getCurrentUser()?.objectId
                
                if(participantId != creatorId){

                    var install:PFInstallation = pfObject["installation"] as! PFInstallation
        
                    var pushQuery:PFQuery = PFInstallation.query()!
                
                    pushQuery.whereKey("objectId", equalTo: install.objectId!)
        
                    var pfPush: PFPush = PFPush()
        
                    pfPush.setQuery(pushQuery)
        
                    pfPush.setMessage("\(creator) convocated you for a meeting")
                                
                    pfPush.sendPushInBackground()
                }
            }
        }
    }
}
