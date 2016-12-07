//
//  RemindersViewModel.swift
//  Bene
//
//  Created by David Mar Alvarez on 7/15/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import Foundation
import UIKit

struct DoctorReminder {
    
    let doctor: DoctorViewModel
    let fecha: String
    
    init?(notification: UILocalNotification) {
        
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let notificationDoctor = DoctorViewModel(foundationRepresentation: userInfo),
            let fireDate = notification.fireDate else { return nil }
        
        doctor = notificationDoctor
        fecha = fireDate.hospitalDateFormatter()
    }
    
}

struct MedicineReminder {

    let name: String
    let dose: String
    let interval: NSTimeInterval
    private let nameKey = "name"
    private let doseKey = "dose"
    private let intervalKey = "interval"
    
    init?(notification: UILocalNotification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
                let nameInfo = userInfo[nameKey] as? String,
                let doseInfo = userInfo[doseKey] as? String,
                let intervalInfo = userInfo[intervalKey] as? NSTimeInterval else { return nil }
        
        name = nameInfo
        interval = intervalInfo
        dose = doseInfo
    }
}

class ReminderListViewModel: ReceivedDoctorReminderDelegate, ReceivedMedicineReminderDelegate {
    
    var doctorReminders = [DoctorReminder]()
    var medicineReminders = [MedicineReminder]()
    
    let NewReminderNotificationName = "newReminderNotification"
    
    class func repeatReminder(notification: UILocalNotification) -> UILocalNotification? {
        guard let interval = notification.userInfo?["interval"] as? NSTimeInterval,
            let fireDate = notification.fireDate else { return nil }
        
        let newFireDate = NSDate(timeIntervalSince1970: fireDate.timeIntervalSince1970 + interval)
        return UILocalNotification.create(fireDate: newFireDate,
                                   alertBody: notification.alertBody,
                                   userInfo: notification.userInfo,
                                   category: notification.category,
                                   interval: interval)
    }
}

// MARK: - Creat Reminders
extension ReminderListViewModel {
    func newDoctorReminder(doctor: DoctorViewModel, date: NSDate) {
        createReminder(date, doctor: doctor, medicine: nil)
    }
    
    func newMedicineReminder(medicineName: String, medicineDose: String, timeInterval: NSTimeInterval) {
        createReminder(nil,
                       doctor: nil,
                       medicine: (name: medicineName, dose: medicineDose, interval: timeInterval))
    }
    
    /**
     Depending on the received parameters sets up a local notification
     */
    private func createReminder(date: NSDate?,
                                doctor givenDoctor: DoctorViewModel?,
                                medicine givenMedicine: (name: String, dose: String, interval: NSTimeInterval)?) {
        
        let alertBody: String
        let userInfo: [NSObject: AnyObject]
        let interval: NSTimeInterval?
        let category: String
        let fireDate: NSDate
        

        if  let doctor = givenDoctor, let date = date {
            
            alertBody = "Tienes una cita con el doctor \(doctor.name) con especialidad en \(doctor.especialidad)"
            userInfo = doctor.foundationRepresentation()
            interval = nil
            category = "Appointment"
            fireDate = date
            
        } else if let medicine = givenMedicine {
            
            let nameKey = "name"
            let intervalKey = "interval"
            let doseKey = "dose"
            let date = NSDate()
            alertBody = "Debes tomar tu dosis de" + medicine.name
            userInfo = [nameKey: medicine.name, doseKey: medicine.dose, intervalKey: medicine.interval]
            interval = medicine.interval
            category = "Medicine"
            fireDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970 + medicine.interval)
            
        } else {
            fatalError("You should pass a doctor or a medicine.")
        }
        
        let notification = UILocalNotification.create(fireDate: fireDate,
                                                      alertBody: alertBody,
                                                      userInfo: userInfo,
                                                      category: category,
                                                      interval: interval)
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(self.NewReminderNotificationName, object: nil)
        }
    }
}

// MARK: - Delete Reminders
extension ReminderListViewModel {
    func deleteMedicineReminder(timeInterval: NSTimeInterval, name: String) {
        deleteReminder(nil, date: nil, timeInterval: timeInterval, name: name)
    }
    
    func deleteDoctorReminder(doctor: DoctorViewModel, date: String?) {
        deleteReminder(doctor, date: date, timeInterval: nil, name: nil)
    }
    
    /**
     Dependending on the given paramaters deletes the specified reminder from the array.
     */
    private func deleteReminder(doctor: DoctorViewModel?, date: String?, timeInterval: NSTimeInterval?, name: String?) {
        
        let app = UIApplication.sharedApplication()
        
        for oneEvent in app.scheduledLocalNotifications! {
            
            let notification = oneEvent as UILocalNotification
            
                guard let doctorNotification = DoctorViewModel(foundationRepresentation: (notification.userInfo as? [String: AnyObject])!),
                    let doctor = doctor,
                    let date = date else {
                        
                    if let timeInterval = timeInterval, let name = name {
                        
                        guard let medicineNotification = MedicineReminder(notification: notification) else { continue }
                        
                        if medicineNotification.interval == timeInterval && medicineNotification.name == name {
                            app.cancelLocalNotification(notification)
                        }
                        
                    }
                    continue
            }
            
            if let notificationFireDate = notification.fireDate?.hospitalDateFormatter() where notificationFireDate == date && doctorNotification.especialidad == doctor.especialidad && doctorNotification.name == doctor.name {
                    app.cancelLocalNotification(notification)
                }
        }
    }
}

// MARK: - Request
extension ReminderListViewModel {
    
    func requestDoctorReminders() {
        doctorReminders = requestReminders("Appointment") { DoctorReminder(notification: $0) }
    }
    
    func requestMedicineReminders() {
        medicineReminders = requestReminders("Medicine") { MedicineReminder(notification: $0) }
    }
    
    /**
     Transforms the UILocalNotification into the required type of notification.
    */
    private func requestReminders<T>(category: String, mapeo: (UILocalNotification -> T?)) -> [T] {
        
        guard let scheduleLocalNotifications = UIApplication.sharedApplication().scheduledLocalNotifications else { return [] }
        
        return scheduleLocalNotifications
            .filter { $0.category == category }
            .map(mapeo)
            .flatMap{ $0 }
    }
}