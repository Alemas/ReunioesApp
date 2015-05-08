//
//  MainMenuViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/8/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func didPressLogout(sender: AnyObject) {
        let closure = {(suceeded:Bool) -> Void in
        
        self.performSegueWithIdentifier("unwindFromMainMenu", sender: nil)
        
        }
        
        User.logout(closure)
    }
}
