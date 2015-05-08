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
    
    class func login(username:String, password:String) {
        
        if (PFUser.currentUser() == nil) {
            
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                
                if let usr:PFUser = user {
                    
                } else {
                    let alert = UIAlertView(title: "Error", message: "Invalid Login Parameters", delegate: nil, cancelButtonTitle: "Ok")
                    alert.show()
                }
            })
        }
    }
    
    class func signUp(username:String, password:String, email:String, company:String) {
        
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email

        user.signUpInBackgroundWithBlock{(succeded, error) -> Void in
         
            if error == nil {
                user["company"] = company
            } else {
                let alert = UIAlertView(title: "Error", message: "Could not Signup", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            
        }
        
    }
    
    class func logout() {
        PFUser.logOutInBackground()
    }
    
    class func getCurrentUser() -> PFUser? {
        return PFUser.currentUser()
    }
    
}
