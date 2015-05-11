//
//  SetAddressViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/11/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit
import MapKit

class SetAddressViewController: UIViewController {
    
    var mapItem: MKMapItem?
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressBack(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindFromSetAddress", sender: nil)
    }
    
}
