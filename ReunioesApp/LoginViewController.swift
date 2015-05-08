//
//  LoginViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/8/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        User.signUp("Uriel", password: "12345", email: "u@gmail.com", company: "BEPiD")
//        User.signUp("Mateus", password: "12345", email: "m@gmail.com", company: "BEPiD")
//        User.signUp("Eduardo", password: "12345", email: "e@gmail.com", company: "BEPiD")
//        User.signUp("Natasha", password: "12345", email: "n@gmail.com", company: "BEPiD")
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressLogin(sender: AnyObject) {
        
        var username = self.txfUsername.text
        var password = self.txfPassword.text
        
        if password == "" || username == ""{
            return
        }
        
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        self.txfPassword.text = ""
        
        let closure = {(succeeded:Bool) -> Void in
                    
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            
            if (User.getCurrentUser() != nil) {
                println(username)
            } else {
                
            }
        
        
        }
        
        User.login(username, password: password, closure: closure)
        
    }

    @IBAction func didPressSignUp(sender: AnyObject) {
        self.performSegueWithIdentifier("showSignup", sender: nil)
        
    }

    @IBAction func unwindFromSignUpSegue(segue:UIStoryboardSegue) {
        
        
        
    }
    @IBAction func didEndEditing(sender: AnyObject) {
        sender.endEditing(true)
    }
    
}
