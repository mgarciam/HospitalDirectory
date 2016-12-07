//
//  MedicineRemindersViewController.swift
//  Bene
//
//  Created by David Mar Alvarez on 7/26/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import Foundation
import UIKit

protocol ReceivedMedicineReminderDelegate {
    func newMedicineReminder(medicineName: String, medicineDose: String, timeInterval: NSTimeInterval)
}

class MedicineRemindersViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var medicineNameTextField: UITextField!
    @IBOutlet var doseTextField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var doneButton: UINavigationItem!
    
    var timeInterval: NSTimeInterval? = 1
    
    var receivedMedicineReminderDelegate: ReceivedMedicineReminderDelegate?
    
    var pickerDataSource = Array(1...24).map { (numero) -> String in
        guard numero == 1 else { return "\(numero) Horas" }
        return "\(numero) Hora"
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.doseTextField.delegate = self
        self.medicineNameTextField.delegate = self
        self.hideKeyboardWhenTappingAround()
    }
    
    @IBAction func didPressCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressDoneButton(sender: AnyObject) {
        
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() where settings.types != .None else {
            presentViewController(UIAlertController.createSettingsAlert(), animated: true, completion: nil)
            return
        }
        
       
        guard let timeInterval = timeInterval, let medicineName = medicineNameTextField.text, let dose = doseTextField.text else { return }
        receivedMedicineReminderDelegate?.newMedicineReminder(medicineName, medicineDose: dose, timeInterval: timeInterval)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     
     Enables the done button only if the two textFields have more than 1 character
     
     - parameter textField: <#textField description#>
     - parameter range:     <#range description#>
     - parameter string:    <#string description#>
     
     - returns: <#return value description#>
     */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if let textFieldText = textField.text {
            let newTextField = textFieldText + string
            if textField.text == medicineNameTextField.text {
                
                if newTextField.characters.count > 1 && doseTextField.hasText() {
                    doneButton.rightBarButtonItem?.enabled = true
                    return true
                }
            } else if newTextField.characters.count > 1 && medicineNameTextField.hasText(){
                doneButton.rightBarButtonItem?.enabled = true
                return true
            }
            doneButton.rightBarButtonItem?.enabled = false
        }
        return true
    }
}

// MARK: - UIPickerView delegate Methods
extension MedicineRemindersViewController {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerDataSource[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeInterval = NSTimeInterval(row + 1)
    }
}