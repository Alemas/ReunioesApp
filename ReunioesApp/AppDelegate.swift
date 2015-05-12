//
//  AppDelegate.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/6/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit
import Parse
import Bolts
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager = CLLocationManager()
    var beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "93069B63-F90A-4F7C-85F8-72132FFA9966"), identifier: "imeeting")
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("adCK5M81sWruTioEdxDpg8raw9j487zeeQ2twRba",
            clientKey: "AzAqAJqMkLj2SXjNw9wzszAcVf3qdg8jf3j1flVh")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        var type = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound;
        var settings = UIUserNotificationSettings(forTypes: type, categories: nil);
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        //ibeacon
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        return true
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.AuthorizedAlways){
            locationManager.startMonitoringForRegion(self.beaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
//        if(User.getCurrentUser() != nil){
//            for beacon in beacons{
//                let meet = User.getMeetingForMinorAndMajor((beacon as! CLBeacon).minor.integerValue, (beacon as! CLBeacon).major.integerValue)
//                var query = PFQuery(className: "Meeting_User")
//                query.whereKey("user", equalTo: User.getCurrentUser()!)
//                query.whereKey("meeting", equalTo: meet)
//                let result:NSArray = query.findObjects()!
//                if(result.count>0){
//                    var obj:PFObject = result[0] as! PFObject
//                    obj["present"]=true
//                    obj.save()
//                }
//            }
//        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.channels = ["HAHAHA"]
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    
    
}

