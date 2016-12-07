//
//  UILocalNotification-Extension.swift
//  Bene
//
//  Created by David Mar Alvarez on 7/25/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import Foundation
import UIKit

extension UILocalNotification {
    
    class func create(fireDate fireDate: NSDate,
                                alertBody: String?,
                                userInfo: [NSObject: AnyObject]?,
                                category: String?,
                                interval: NSTimeInterval?) -> UILocalNotification {
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = fireDate
        localNotification.alertBody = alertBody
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.userInfo = userInfo
        localNotification.category = category
        
        if interval != nil {
            localNotification.repeatInterval = NSCalendarUnit.Hour
        }
        
        return localNotification
    }
}