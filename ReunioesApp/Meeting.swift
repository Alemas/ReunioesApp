//
//  Meeting.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/8/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit
import Parse
import MapKit

class Meeting: NSObject {
    
    var subject:String
    var creator:PFUser
    var participants:NSMutableArray
    var address:String
    var date:NSDate
    var tolerance:Int
    var minorAndMajor:NSArray
    var coordinate:NSArray
    var extraInfo:String
    
    init(subject:String, creator:PFUser, participants:NSArray, address:String, date:NSDate, tolerance:Int, minorAndMajor:NSArray, coordinate:NSArray, extraInfo:String) {
        
        self.subject = subject
        self.creator = creator
        self.participants = NSMutableArray(array:participants)
        self.address = address
        self.date = date
        self.tolerance = tolerance
        self.minorAndMajor = minorAndMajor
        self.coordinate = coordinate
        self.extraInfo = extraInfo
        
    }
   
}
