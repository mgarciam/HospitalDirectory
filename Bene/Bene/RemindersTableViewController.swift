//
//  RemindersViewController.swift
//  Bene
//
//  Created by David Mar Alvarez on 7/1/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import Foundation
import UIKit

class RemindersTableViewController: UITableViewController {
    
    @IBOutlet weak var remindersSegmentedControl: UISegmentedControl!
    
    var reminderListViewModel = ReminderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(didUpdateReminders),
                                                         name: reminderListViewModel.NewReminderNotificationName,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(didUpdateReminders),
                                                         name: "reloadReminders",
                                                         object: nil)

        requestReminderDependingOnSection()
    }
    
    /**
     presents the customized screen depending on the segmented Control selection
     */
    @IBAction func presentCustomizedRemindersScreen(sender: AnyObject) {
        
        let storyBoardIndentifier = "Reminders"
        var viewControllerIdentifier: String
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        if remindersSegmentedControl.selectedSegmentIndex == 0 {
            viewControllerIdentifier = "doctorNavigationBar"
        } else {
            viewControllerIdentifier = "medicinesNavigationController"
        }
        
        let storyBoard = UIStoryboard(name: storyBoardIndentifier, bundle: nil)
        let viewController = storyBoard.instantiateViewControllerWithIdentifier(viewControllerIdentifier)
        
        self.presentViewController(viewController, animated: true, completion: nil)
        
        if let viewControllerNavBar = viewController as? UINavigationController, let medicineViewController = viewControllerNavBar.topViewController as? MedicineRemindersViewController {
            
                let reminderListViewModel = ReminderListViewModel()
                medicineViewController.receivedMedicineReminderDelegate = reminderListViewModel
            }
    
        }
    
    private func requestReminderDependingOnSection() {
        guard remindersSegmentedControl.selectedSegmentIndex == 1 else {
            reminderListViewModel.requestDoctorReminders()
            return
        }
        reminderListViewModel.requestMedicineReminders()
    }
}


// MARK: - UITableViewDataSource
extension RemindersTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let (givenDoctorReminders, givenMedicineReminders) = requestDataSource()
        
        guard let doctorReminders = givenDoctorReminders else {
            if let medicineReminders = givenMedicineReminders {
                return medicineReminders.count
            }
            return 0
        }
        return doctorReminders.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reminderCell", forIndexPath: indexPath)
        
        let(givenMedicineReminders, givenDoctorReminders) = requestDataSource()
        
        if let medicineReminders = givenMedicineReminders {
            
            let reminderAtIndexPathForMedicine = medicineReminders[indexPath.row]
            cell.textLabel?.text = reminderAtIndexPathForMedicine.name
            cell.detailTextLabel?.text = reminderAtIndexPathForMedicine.dose
            
        } else if let doctorReminders = givenDoctorReminders {
            
            let reminderAtIndexPathForDoctor = doctorReminders[indexPath.row]
            cell.textLabel?.text = reminderAtIndexPathForDoctor.doctor.name
            cell.detailTextLabel?.text = reminderAtIndexPathForDoctor.fecha
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard editingStyle == .Delete else { return }
        
        let (givenMedicineReminders, givenDoctorReminders) = requestDataSource()
        
        if let medicineReminders = givenMedicineReminders {
            let medicineReminderAtIndexPath = medicineReminders[indexPath.row]
            reminderListViewModel.deleteMedicineReminder(medicineReminderAtIndexPath.interval, name: medicineReminderAtIndexPath.name)
        } else if let doctorReminder = givenDoctorReminders {
            let doctorReminderArIndexPath = doctorReminder[indexPath.row]
            reminderListViewModel.deleteDoctorReminder(doctorReminderArIndexPath.doctor, date: doctorReminderArIndexPath.fecha)
        }
        requestReminderDependingOnSection()
        tableView.reloadData()
    }
    
    private func requestDataSource() -> ([MedicineReminder]?, [DoctorReminder]?)  {
        
        guard remindersSegmentedControl.selectedSegmentIndex == 0 else {
            return (reminderListViewModel.medicineReminders, nil)
        }
        return (nil, reminderListViewModel.doctorReminders)
    }
}

// MARK: - Notifications
extension RemindersTableViewController {
    
    func didUpdateReminders(Notification: NSNotification) {
        requestReminderDependingOnSection()
        tableView.reloadData()
    }
}

// MARK: - Segmented Control
extension RemindersTableViewController {
    @IBAction func segmentControlChanged(sender: UISegmentedControl) {
        requestReminderDependingOnSection()
        tableView.reloadData()
    }
}
