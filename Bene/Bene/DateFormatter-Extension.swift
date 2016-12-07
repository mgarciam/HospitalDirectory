//
//   DateFormatter-Extension.swift
//  Bene
//
//  Created by David Mar Alvarez on 7/27/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import Foundation

extension NSDate {
    func hospitalDateFormatter() -> String {
        return NSDateFormatter.hospitalDateFormatter.stringFromDate(self)
    }
}

extension NSDateFormatter {
    
    private static var hospitalDateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter
    }()
}