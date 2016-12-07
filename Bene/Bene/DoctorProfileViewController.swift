//
//  DoctorProfileViewController.swift
//  Bene
//
//  Created by Marilyn García on 7/14/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import UIKit

class DoctorProfileViewController: UITableViewController {
    
    var doctorProfile = DoctorViewModel(nombre: "", especialidad: "")
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
     
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath)
       
        var detailText = ""
        var infoText = ""
        switch indexPath.row {
            
        case 0:
            detailText = "Nombre: "
            infoText = doctorProfile.name
                
        case 1:
            detailText = "Especialidad: "
            infoText = doctorProfile.especialidad
                
        default: break
            
        }
        
        cell.detailTextLabel?.text = infoText
        cell.textLabel?.text = detailText
        
        return cell
    }
}

    

