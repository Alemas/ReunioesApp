//
//  iBeaconTransmitterTableViewController.swift
//  ReunioesApp
//
//  Created by Uriel on 11/05/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import Parse

let uuid = NSUUID(UUIDString: "93069B63-F90A-4F7C-85F8-72132FFA9966")
let identifier = "imeeting"

class iBeaconTransmitterTableViewController: UITableViewController, CBPeripheralManagerDelegate {
    
    var peripheralManager: CBPeripheralManager?
    var beaconRegion : CLBeaconRegion?
    
    var major: Int?
    var minor: Int?
    var inviteds: NSArray?
    var timer: NSTimer?
    var makingQuery:Bool = false
    
    var meeting:PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: CLBeaconMajorValue(self.major!), minor: CLBeaconMinorValue(self.minor!), identifier: identifier)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: dispatch_get_main_queue())
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT

        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.meeting = User.getMeetingForMinorAndMajor(self.minor!, major: self.major!)
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if (timer != nil) {
            timer!.invalidate()
        }
    }
    
    func update(){
        if view == nil {
            return
        }
        
        var query = PFQuery(className: "Meeting_User")
        if (self.meeting != nil && !self.makingQuery){
            self.makingQuery = true
            query.whereKey("meeting", equalTo: self.meeting!)
            query.findObjectsInBackgroundWithBlock({ (result, error) -> Void in
                self.makingQuery = false
                if error == nil {
                    self.inviteds = result
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    //MARK: CBPeripheralDelegate
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        switch (peripheral.state) {
        case .PoweredOn:
            var peripheralData = beaconRegion!.peripheralDataWithMeasuredPower(-59)
            self.peripheralManager!.startAdvertising((peripheralData as NSDictionary as! [NSObject:AnyObject]))
        default:
            break
        }
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
        println("Peripheral started with error: \(error?.localizedDescription)")
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let check = cell.viewWithTag(10) as! UIImageView
        let name = cell.viewWithTag(20) as! UILabel
        let present = (self.inviteds![indexPath.row] as! PFObject)
        let user = present["user"] as! PFUser
        name.text = (user["realName"] as! String)
        if((present["present"] as! Bool) == false){
            check.hidden = true
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.inviteds != nil{
            return self.inviteds!.count
        }
        return 0
    }
    
}
