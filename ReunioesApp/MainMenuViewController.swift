//
//  MainMenuViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/8/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.enableInputs()
        if self.lblName.text == "" {
            self.lblName.text = "Welcome \(User.getRealName())"
        }
        if self.lblCompany.text == ""{
            self.lblCompany.text = "Company: \(User.getCompany())"
        }
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
    
    @IBAction func didPressNewMeeting(sender: AnyObject) {
        self.performSegueWithIdentifier("showNewMeeting", sender: nil)
    }
    @IBAction func didPressMeetings(sender: AnyObject) {
        self.performSegueWithIdentifier("showMeetings", sender: nil)
    }

    @IBAction func didPressLogout(sender: AnyObject) {
        self.disableInputs()
        let closure = {(suceeded:Bool) -> Void in

            self.performSegueWithIdentifier("unwindFromMainMenu", sender: nil)
            
        }
        
        User.logout(closure)
    }
    
    @IBAction func unwindFromSettings(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromNewMeeting(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromMeetings(segue:UIStoryboardSegue) {
        
    }
    
    
    
    
    
}
