//
//  Meeting.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/8/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit
import Parse

class Meeting: NSObject {
    
    var subject:String
    var creator:PFUser
    var attendee:NSMutableArray
    var address:String
    var date:NSDate
    var tolerance:Int
    
    init(subject:String, creator:PFUser, attendee:NSMutableArray, address:String, date:NSDate, tolerance:Int) {
        
        self.subject = subject
        self.creator = creator
        self.attendee = attendee
        self.address = address
        self.date = date
        self.tolerance = tolerance
        
    }
   
}
