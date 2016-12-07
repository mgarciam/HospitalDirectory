//
//  AppDelegate.swift
//  Bene
//
//  Created by David Mar Alvarez on 6/24/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import UIKit
import SafariServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController() as! UITabBarController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        let doctores = UIStoryboard(name: "Doctores", bundle: nil).instantiateInitialViewController()!
        doctores.tabBarItem = UITabBarItem(title: doctores.title, image: UIImage(named: "directorio")?.imageWithRenderingMode(.AlwaysOriginal), tag: 0)
        
        let reminders = UIStoryboard(name: "Reminders", bundle: nil).instantiateInitialViewController()!
        reminders.tabBarItem = UITabBarItem(title: reminders.title, image: UIImage(named: "reminders")?.imageWithRenderingMode(.AlwaysOriginal), tag: 1)
        
       
        let preRegister = UIStoryboard(name: "PreRegister", bundle: nil).instantiateInitialViewController()!
        preRegister.tabBarItem = UITabBarItem(title: preRegister.title, image: UIImage(named: "PreRegister")?.imageWithRenderingMode(.AlwaysOriginal), tag: 2)
        
        let about = UIStoryboard(name: "About", bundle: nil).instantiateInitialViewController()!
        about.tabBarItem = UITabBarItem(title: about.title, image: UIImage(named: "about")?.imageWithRenderingMode(.AlwaysOriginal), tag: 3)
        
        
        initialViewController.viewControllers = [
            doctores,
            reminders,
            preRegister,
            about
        ]
   
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if( application.applicationState == .Active) {
            let notificationAlertWhenAppIsOpen = UIAlertController(title: notification.alertTitle,
                                                                     message: notification.alertBody,
                                                                     preferredStyle: .Alert)
            
            let cancel = UIAlertAction(title: "OK", style: .Default ) { action in
                notificationAlertWhenAppIsOpen.dismissViewControllerAnimated(true, completion: nil)
            }
            notificationAlertWhenAppIsOpen.addAction(cancel)
            window?.rootViewController?.showViewController(notificationAlertWhenAppIsOpen, sender: nil)
            
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotificationName("reloadReminders", object: nil)
            }
        }
    }
}