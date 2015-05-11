//
//  LoginViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/8/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.activityIndicator.stopAnimating()
        if User.getCurrentUser() != nil {
            self.performSegueWithIdentifier("showMainMenu", sender: nil)
        }
    }
    
    func login(){
        
        self.activityIndicator.startAnimating()
        
        let closure = {(succeeded:Bool) -> Void in
            
            self.activityIndicator.stopAnimating()
            
            if (succeeded) {
                self.performSegueWithIdentifier("showMainMenu", sender: nil)
            } else {
                var alert = UIAlertView(title: "Error", message: "Invalid Login Paramenters", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            
        }
        
        User.login(txfUsername.text, password: txfPassword.text, closure: closure)
        
        self.txfPassword.text = ""

    }
    
    @IBAction func didPressLogin(sender: AnyObject) {
        
        var username = self.txfUsername.text
        var password = self.txfPassword.text
        
        if password == "" || username == ""{
            var alert = UIAlertView(title: "Error", message: "You must inform username and password", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
            return
        }
        
        self.login()
        
    }

    @IBAction func didPressSignUp(sender: AnyObject) {
        self.performSegueWithIdentifier("showSignUp", sender: nil)
    }

    @IBAction func unwindFromSignUpSegue(segue:UIStoryboardSegue) {
        let vc:SignUpViewController = segue.sourceViewController as! SignUpViewController
        if vc.didCreateNewAccount {
            self.login()
        }
    }
    
    @IBAction func unwindFromMainMenuSegue(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func didEndEditing(sender: AnyObject) {
        sender.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.returnKeyType == UIReturnKeyType.Next {
            self.txfPassword.becomeFirstResponder()
        }
        if textField.returnKeyType == UIReturnKeyType.Go {
            self.login()
        }
        
        return true
    }
    
}
