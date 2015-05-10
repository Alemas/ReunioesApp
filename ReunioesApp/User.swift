//
//  User.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/7/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit
import Parse
import Bolts

class User: NSObject {
    
    class func login(username:String, password:String, closure:(Bool)->Void) {
        
        if (PFUser.currentUser() == nil) {
            
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                
                if let usr:PFUser = user {
                    closure(true)
                } else {
                    closure(false)
                }
            })
        }
    }
    
    class func signUp(username:String, password:String, email:String, company:String, realName:String, closure:(Bool)->Void) {
        
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        user["company"] = company
        user["realName"] = realName

        user.signUpInBackgroundWithBlock{(succeeded, error) -> Void in
         
            if error == nil {
                closure(true)
                self.registerCompany(company)
            } else {
                closure(false)
            }
            
        }
        
    }
    
    class private func registerCompany(company:String) {
        
        let query = PFQuery(className: "Company")
        query.whereKey("name", equalTo: company)
        
        query.findObjectsInBackgroundWithBlock({(result, error) -> Void in
        
            if result!.isEmpty {
                var obj = PFObject(className: "Company")
                obj["name"] = company
                obj.save()
            }
        
        })
       
        
    }
    
    class func getRealName() -> String {
        
        if let user = User.getCurrentUser() {
            return user["realName"] as! String
        }
        return ""
    }
    
    class func getCompany() -> String {
        
        if let user = User.getCurrentUser() {
            return user["company"] as! String
        }
        return ""
        
    }
    
    class func getColleagues() -> NSArray {
        
        if let user = User.getCurrentUser() {
            let query = PFQuery(className: "_User")
            let company = User.getCompany()
            query.whereKey("company", equalTo: company)
            let result = query.findObjects()!
            return result
        }
        return []
        
    }
    
    class func getMeetings() -> NSArray {
        
        if (User.getCurrentUser() == nil){
            return []
        }
        
        let query = PFQuery(className: "Meeting")
        query.whereKey("participants", equalTo: User.getCurrentUser()!)
        
        var array = NSArray()
        
        query.findObjectsInBackgroundWithBlock{(objects, error) -> Void in
            array = objects!
        }
        
        if array.count>0 {
            
            var meetingsArray = NSMutableArray()
        
            for o in array {
            
                let obj = o as! PFObject
                
                let meeting = Meeting(subject: obj["subject"] as! String,
                    creator: obj["creator"] as! PFUser,
                    participants: obj["participants"] as! NSArray,
                    address: obj["address"] as! String,
                    date: obj["date"] as! NSDate,
                    tolerance: obj["tolerance"] as! Int)
                
                meetingsArray.addObject(meeting)
            
            }
            
            return meetingsArray
        }
        
        return array
    }
    
    class func logout(closure:(Bool) -> Void) {
        PFUser.logOutInBackgroundWithBlock({(error) -> Void in
            
            if error == nil {
                closure(true)
            } else {
                closure(false)
            }
            
        })
    }
    
    class func getCurrentUser() -> PFUser? {
        return PFUser.currentUser()
    }
    
}
