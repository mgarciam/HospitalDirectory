//
//  DirectorioDeDoctoresTableViewController.swift
//  Bene
//
//  Created by David Mar Alvarez on 6/25/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import UIKit

/// Provides a directory of doctors, where each section is a grouping of doctors by specialty.
class DirectorioDoctoresTableViewController: UITableViewController {
    
    private let viewModel = DoctoresViewModel()
    //    let selectedDoctor = DoctorProfileViewController()
    
    lazy var resultSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = controller.searchBar
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationForReceivedDoctors = viewModel.requestDoctors(specialty: nil)
        
        /**
         Listens for the notification then reloads the Table View
         */
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(didUpdateDoctors),
                                                         name: notificationForReceivedDoctors,
                                                         object: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PresentProfile",
            let cell = sender as? UITableViewCell,
            let selectedIndexPath = tableView.indexPathForCell(cell) {
        
            let doctors = doctorsForSection(selectedIndexPath.section)
            let doctor = doctors[selectedIndexPath.row]
            let destinationController = (segue.destinationViewController as! UITableViewController) as! DoctorProfileViewController
            destinationController.doctorProfile = doctor
            resultSearchController.dismissViewControllerAnimated(false, completion: nil)
        }
        
        if let navigationController = segue.destinationViewController as? UINavigationController where segue.identifier == "ModalFilterSegue" {
            if let filtersSpecialtiesVC = navigationController.visibleViewController as? FilterSpecialtiesViewController {
                filtersSpecialtiesVC.filterDelegate = self
            }
        }
        
        if segue.identifier == "showDatePicker",
            let cell = sender as? UITableViewCell,
            let selectedIndexPath = tableView.indexPathForCell(cell),
            let datePickerVC = segue.destinationViewController as? DatePickerViewController {
            
            let doctors = doctorsForSection(selectedIndexPath.section)
            let doctor = doctors[selectedIndexPath.row]
            datePickerVC.doctor = doctor
            let reminderListViewModel = ReminderListViewModel()
            datePickerVC.reminderDelegate = reminderListViewModel
            
            resultSearchController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource
extension DirectorioDoctoresTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if resultSearchController.active  {
            guard let sections = viewModel.lettersForFilteredDoctors?.count else { return 0 }
            return sections
        } else {
            return viewModel.letters.count
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorsForSection(section).count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DoctorNameCell", forIndexPath: indexPath)
        let doctorsWithSpecialty = doctorsForSection(indexPath.section)
        let doctorAtIndexPath = doctorsWithSpecialty[indexPath.row]
        cell.textLabel?.text = doctorAtIndexPath.name
        cell.detailTextLabel?.text = doctorAtIndexPath.especialidad
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if resultSearchController.active {
            guard let title = viewModel.lettersForFilteredDoctors?[section] else { return nil }
            return title
        } else {
            return viewModel.letters[section]
        }
    }
    
    /**
     Returns the doctors by their name's first letter either if they are filtered or not
     
     - returns: An array of doctors
     */
    private func doctorsForSection(section: Int) -> [DoctorViewModel] {
        let key: String
        let doctors: [DoctorViewModel]
        
        if resultSearchController.active, let key = viewModel.lettersForFilteredDoctors?[section], let doctorsForKey = viewModel.doctorsWhenSearching?[key] {
            doctors = doctorsForKey
        } else {
            key = viewModel.letters[section]
            guard let doctorsForKey = viewModel.doctorsGroupedAlphabetically[key] else { return [] }
            doctors = doctorsForKey
        }
        
        return doctors
    }
}


// MARK: - Notifications
extension DirectorioDoctoresTableViewController {
    func didUpdateDoctors(notification: NSNotification) {
        self.tableView.reloadData()
    }
}

// MARK: - SearchBar
extension DirectorioDoctoresTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        viewModel.temporarySearchedDoctors(query: searchController.searchBar.text)
        self.tableView.reloadData()
    }
}

// MARK: - FilterSpecialtyDelegate
extension DirectorioDoctoresTableViewController: FilterSpecialtyDelegate {
    func filterRequest(specialty: String?) {
        viewModel.requestDoctors(specialty: specialty)
    }
}

// MARK: - CancelButton
extension DirectorioDoctoresTableViewController {
    
    @IBAction func didTouchUpInsideCancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}