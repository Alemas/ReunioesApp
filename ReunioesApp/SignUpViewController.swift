//
//  SignUpViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/8/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txfUsername: UITextField!
    @IBOutlet weak var txfRealName: UITextField!
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfCompany: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfConfirmPassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        
    var didCreateNewAccount = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func disableInputs(){
        for subview in self.view.subviews {
            if subview.isKindOfClass(UIButton) {
                (subview as! UIButton).enabled = false
            }
        }
    }
    
    func enableInputs(){
        for subview in self.view.subviews {
            if subview.isKindOfClass(UIButton) {
                (subview as! UIButton).enabled = true
            }
        }
    }
    
    func validFields() -> Bool {
        
        if self.txfUsername.text != "" && self.txfRealName.text != "" &&
            self.txfEmail.text != "" && txfPassword != "" && txfEmail.text != "" &&
            self.txfCompany.text != "" && self.txfPassword.text == self.txfConfirmPassword.text {
                return true
        }
        return false
        
    }
    
    func signUp() {
        
        self.activityIndicator.hidden = false
        self.disableInputs()
        
        let closure = {(succeeded:Bool) -> Void in
            
            self.activityIndicator.hidden = true
            self.enableInputs()
            
            if succeeded {
                self.didCreateNewAccount = true
                self.performSegueWithIdentifier("unwindFromSignUp", sender: nil)
            } else {
                var alert = UIAlertView(title: "Error", message: "Invalid Parameters", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            
        }
        
        User.signUp(txfUsername.text, password: txfPassword.text, email: txfEmail.text, company: txfCompany.text, realName: txfRealName.text, closure: closure)
        
    }
    
    @IBAction func didPressRegister(sender: AnyObject) {
        
        if !validFields() {
            var alert = UIAlertView(title: "Error", message: "Invalid Parameters", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
            return
        }
        
        self.signUp()
        
    }
    
    @IBAction func didPressCancel(sender: AnyObject) {
         self.performSegueWithIdentifier("unwindFromSignUp", sender: nil)
    }
    
    @IBAction func didEndEditing(sender: AnyObject) {
        sender.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == self.txfUsername {
            self.txfRealName.becomeFirstResponder()
        }
        if textField == self.txfRealName {
            self.txfEmail.becomeFirstResponder()
        }
        if textField == self.txfEmail {
            self.txfCompany.becomeFirstResponder()
        }
        if textField == self.txfCompany {
            self.txfPassword.becomeFirstResponder()
        }
        if textField == self.txfPassword {
            self.txfConfirmPassword.becomeFirstResponder()
        }
        if textField == self.txfConfirmPassword {
            self.signUp()
        }
        return true
    }
    
}
