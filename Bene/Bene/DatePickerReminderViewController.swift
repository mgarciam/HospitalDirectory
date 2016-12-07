//
//  DatePickerReminderViewController.swift
//  Bene
//
//  Created by David Mar Alvarez on 7/20/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import Foundation
import UIKit

protocol ReceivedDoctorReminderDelegate {
     func newDoctorReminder(doctor: DoctorViewModel, date: NSDate)
}

class DatePickerViewController: UIViewController {
    
    let currentDay = NSDate()
    var doctor: DoctorViewModel?
    var reminderDelegate: ReceivedDoctorReminderDelegate?
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = NSDate()
    }
    
    @IBAction func confirmAppointment(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func checkValidDate(sender: AnyObject) {
        if datePicker.date.timeIntervalSinceNow.isSignMinus {
            self.loadView()
        }
    }
    @IBAction func didPressDoneButton(sender: UIBarButtonItem) {
        
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() where settings.types != .None,
            let doctor = doctor else {
            presentViewController(UIAlertController.createSettingsAlert(), animated: true, completion: nil)
            return
        }
        
        reminderDelegate?.newDoctorReminder(doctor, date: datePicker.date)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}