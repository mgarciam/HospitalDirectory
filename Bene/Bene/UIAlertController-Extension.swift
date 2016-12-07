//
//  UIAlertController-Extension.swift
//  Bene
//
//  Created by David Mar Alvarez on 8/3/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    class func createSettingsAlert() -> UIAlertController {
        
        let notificationSettingsInvalidAlert = UIAlertController(title: "No se puede realizar un recordatorio",
                                                                 message: "Activa las notificaciones",
                                                                 preferredStyle: .Alert)
    
        let settings = UIAlertAction(title: "Configuraciones", style: .Default) { action in
            let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)!
            UIApplication.sharedApplication().openURL(settingsURL)
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .Cancel ) { action in
            notificationSettingsInvalidAlert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        notificationSettingsInvalidAlert.addAction(settings)
        notificationSettingsInvalidAlert.addAction(cancel)
        return notificationSettingsInvalidAlert
    }
}