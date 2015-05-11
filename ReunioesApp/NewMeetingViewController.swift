//
//  NewMeetingViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/9/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit

class NewMeetingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var txfTolerance: UITextField!
    @IBOutlet weak var txfDate: UITextField!
    @IBOutlet weak var txfSubject: UITextField!
    @IBOutlet weak var txvAddress: UITextView!
    
    var didCreateNewMeeting = false
    var participants = NSMutableArray(array: [User.getCurrentUser()!])
    var toleranceValues = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txvAddress.layer.borderWidth = 1.0
        self.txvAddress.layer.borderColor = UIColor.lightGrayColor().CGColor
        
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
            self.toleranceValues.addObject("\(i*5) min")
        }
        
        tolerancePicker.backgroundColor = UIColor.whiteColor()
        
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
        
        if segue.identifier=="showSelectParticipants" {
            var vc = (segue.destinationViewController as!UINavigationController).childViewControllers[0] as! SelectParticipantsTableViewController
            vc.participants = self.participants
        }
        
    }
    
    @IBAction func unwindFromSelectParticipants(segue:UIStoryboardSegue) {
        
        
    }
    
    @IBAction func unwindFromSetAddress(segue:UIStoryboardSegue) {
        
        
    }
    
    func didChangeDatePickerValue(sender:UIDatePicker) {
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MMM/dd/yyyy hh:mm a"
        let date = formatter.stringFromDate(sender.date)
        self.txfDate.text = date
        
    }
    
    @IBAction func didPressSelectAddress(sender: AnyObject) {
        
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
        return toleranceValues[row] as! String
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txfTolerance.text = self.toleranceValues[row] as! String
    }
    
    @IBAction func didEndEditing(sender: AnyObject) {
        sender.resignFirstResponder()
    }
}
