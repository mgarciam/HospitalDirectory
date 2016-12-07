//
//  UIViewController-Extension.swift
//  Bene
//
//  Created by David Mar Alvarez on 8/1/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappingAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
   @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}