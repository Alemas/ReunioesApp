//
//  iBeaconTransmitterViewController.swift
//  ReunioesApp
//
//  Created by Uriel on 11/05/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

let uuid = NSUUID(UUIDString: "93069B63-F90A-4F7C-85F8-72132FFA9966")
let identifier = "imeeting"

class iBeaconTransmitterViewController: UIViewController, CBPeripheralManagerDelegate {
    
    var peripheralManager: CBPeripheralManager?
    var beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 1, minor: 1, identifier: identifier)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: dispatch_get_main_queue())
    }
    
    //MARK: CBPeripheralDelegate
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        switch (peripheral.state) {
        case .PoweredOn:
            var peripheralData = beaconRegion.peripheralDataWithMeasuredPower(-59)
            self.peripheralManager!.startAdvertising((peripheralData as NSDictionary as! [NSObject:AnyObject]))
        default:
            break
        }
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
        println("Peripheral started with error: \(error?.localizedDescription)")
        
    }
    
}
