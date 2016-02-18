//
//  AppDelegate.swift
//  NLogSample
//
//  Created by Nghia Nguyen on 2/12/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit
import NLog

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = UINavigationController(rootViewController: NLogViewController())
        window?.makeKeyAndVisible()
        
        NLog.rollingFrequency = 5 * 60
        NLog.limitDisplayedCharacters = 1000
        NLog.displayedLevels = NLog.kDebugLevels
        
        NLog.d("directory=\(UserDirectory)")
        NLog.e("abc")
        
        NLog.saveToFile(UserDirectory + "/log.txt")
        
        return true
    }
    
    func testLog() {
        Delay(2) { () -> Void in
            NLog.d("Test debug")
            NLog.i("Test info \(NSDate().timeIntervalSince1970)")
            self.testLog()
        }
    }
    
    func Delay(seconds: NSTimeInterval, _ queue: dispatch_queue_t = dispatch_get_main_queue(), _ completion: () -> Void) {
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(delay, queue, { () -> Void in
            completion()
        })
        
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


}

var UserDirectory: String {
    return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
}

var LibraryDirectory: String {
    return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, .AllDomainsMask, true)[0]
}

