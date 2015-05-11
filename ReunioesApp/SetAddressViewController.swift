//
//  SetAddressViewController.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/11/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit
import MapKit

class SetAddressViewController: UIViewController, MKMapViewDelegate {
    
    var address:String?
    var coordinate:NSArray?
    var matchingItems: [MKMapItem] = [MKMapItem]()
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        //mapView.centerCoordinate = userLocation.location.coordinate
    }

    //Zoom in to user location
    @IBAction func findMe(sender: AnyObject) {
        
        let userLocation = mapView.userLocation
        println(userLocation.title)
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location.coordinate, 2000, 2000)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    //Change map type between Standard and Bybrid
    @IBAction func mapType(sender: AnyObject) {
        
        if mapView.mapType == MKMapType.Standard {
            mapView.mapType = MKMapType.Hybrid
        } else {
            mapView.mapType = MKMapType.Standard
        }
    }
    
    //Return the typed search
    @IBAction func textFieldReturn(sender: AnyObject) {
        
        sender.resignFirstResponder()
        mapView.removeAnnotations(mapView.annotations)
        self.performSearch()
    }
    
    //Performs local search
    func performSearch() {
        
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler({(response:
            MKLocalSearchResponse!,
            error: NSError!) in
            
            if error != nil {
                println("Error occured in search: \(error.localizedDescription)")
            } else if response.mapItems.count == 0 {
                println("No matches found")
            } else {
                println("Matches found")
                
                for item in response.mapItems as! [MKMapItem] {
                    println("Name = \(item.name)")
                    println("Phone = \(item.phoneNumber)")
                    
                    self.matchingItems.append(item as MKMapItem)
                    println("Matching items = \(self.matchingItems.count)")
                    
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    // Here we add disclosure button inside annotation window
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            println("my location")
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            //println("Pinview was nil")
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        
        var button = UIButton.buttonWithType(UIButtonType.ContactAdd) as! UIButton // button with info sign in it
        
        pinView?.rightCalloutAccessoryView = button
        
        
        return pinView
    }
    
    
    //Segue to return pin coordinates
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if control == view.rightCalloutAccessoryView{
            
            self.address = view.annotation.title
            self.coordinate = [view.annotation.coordinate.latitude, view.annotation.coordinate.longitude]
            
            view.annotation.coordinate
            println(view.annotation.title) // annotation's title
            println(view.annotation.subtitle) // annotation's subttitle
            
            //Perform a segue here to navigate to another viewcontroller
            // On tapping the disclosure button you will get here
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressBack(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindFromSetAddress", sender: nil)
    }

}
