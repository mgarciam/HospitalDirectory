    //
//  filterSpecialtiesViewController.swift
//  Bene
//
//  Created by David Mar Alvarez on 7/8/16.
//  Copyright © 2016 davidmar. All rights reserved.
//
    
import UIKit
    
protocol FilterSpecialtyDelegate {
    func filterRequest(specialty: String?)
}

class FilterSpecialtiesViewController: UITableViewController {
    
    private let viewModel = DoctoresViewModel()
    var filterDelegate: FilterSpecialtyDelegate?
    var specialty: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let notificationForReceivedDoctors = viewModel.requestDoctors(specialty: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(didUpdateSpecialties),
                                                         name: notificationForReceivedDoctors,
                                                         object: nil)
    }
}
    
// Mark: - UITableViewDataSource
extension FilterSpecialtiesViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.specialties.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier("SpecialtyCell", forIndexPath: indexPath)
        cell.textLabel?.text = viewModel.specialties[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        specialty = viewModel.specialties[indexPath.row]
        print(specialty)
    }
}

// Mark: - UIBarButtonItems
extension FilterSpecialtiesViewController {
  
    @IBAction func didTouchUpInsideCancelButton() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressFilterButton() {
        filterDelegate?.filterRequest(specialty)
        didTouchUpInsideCancelButton()
    }
}
    
// MARK: - Notifications
extension FilterSpecialtiesViewController {
    func didUpdateSpecialties(notification: NSNotification) {
       self.tableView.reloadData()
    }
}
