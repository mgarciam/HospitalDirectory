//
//  CallToAPhoneNumber.swift
//  Bene
//
//  Created by David Mar Alvarez on 8/1/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import Foundation
import UIKit

class AbouViewController: UIViewController {
    
    @IBAction func callToAHospital(anyObject: AnyObject) {
        let phoneNumber  = "8332102828"
        let url = NSURL(string: "tel:\(phoneNumber)")
        UIApplication.sharedApplication().openURL(url!)
    }
}