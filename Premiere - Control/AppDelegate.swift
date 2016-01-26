//
//  AppDelegate.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-11-25.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // This is supposed to be the colour of our LEDs
        window?.tintColor = UIColor(red: 0.239, green: 0, blue: 1, alpha: 1)
        
        // Start the netowrking code on a seprait thread
        self.performSelectorInBackground(Selector("networkLoop:"), withObject: nil)
        
        return true
    }
    
    @objc private func networkLoop (_: AnyObject?) {
        Communications.start()
        NSRunLoop.currentRunLoop().run()
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        Data.saveAll()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Data.saveAll()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        Data.saveAll()
    }
}

