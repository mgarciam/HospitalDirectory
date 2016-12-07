//
//  DoctoresViewModel.swift
//  Bene
//
//  Created by David Mar Alvarez on 6/24/16.
//  Copyright © 2016 davidmar. All rights reserved.
//
import UIKit
import Foundation

struct DoctorViewModel {
    
    let name: String
    let especialidad: String
    
    private let especialidadKey = "especialidad"
    private let nombreKey = "nombre"
    
    init(nombre: String, especialidad: String) {
        name = nombre
        self.especialidad = especialidad
    }
    
    init?(foundationRepresentation: [String: AnyObject]) {
        guard let givenName = foundationRepresentation[nombreKey] as? String,
            let givenEspecialidad = foundationRepresentation[especialidadKey] as? String else { return nil }
        
        name = givenName
        especialidad = givenEspecialidad
    }
    
    func foundationRepresentation() -> [String: AnyObject] {
        return [
            especialidadKey: especialidad,
            nombreKey: name
        ]
    }
}

class DoctoresViewModel {
    
    var doctorsGroupedAlphabetically = [String: [DoctorViewModel]]()
    var doctorsWhenSearching: [String: [DoctorViewModel]]?
    var letters = [String]()
    var specialties = [String]()
    var lettersForFilteredDoctors: [String]?
    var doctorsForSearch = [String]()
    
    private let doctoresSource = DoctoresDataSource()

    /**
     Requests an updated list of doctors and specialties from the data source.
     Once the lists are updated, a notification is posted to the main thread (You can subscribe to this notification using the return value as the notification's name).
     
     If refreshing succeeds, the notification's object will be nil.
     If there is an error, the notification will contain the error.

     - returns: the notification's name
     */
    func requestDoctors(specialty specialty: String?) -> String {
        
        let notificationName = "requestDoctores notification"
        
        doctorsGroupedAlphabetically.removeAll()
        letters.removeAll()
        specialties.removeAll()
        
        doctoresSource.fetchDoctores { allDoctors in
            
            // After fetching all doctors, filter based on specialty (if it exists)
            var filteredDoctors = allDoctors
            if let specialtyToFilter = specialty {
                 filteredDoctors = allDoctors.filter { $0.especialidad == specialtyToFilter }
            }
    
            // Now that we have filtered doctors, transform them into viewModel objects and sort them alphabetically.
            for doctor in filteredDoctors {
                
                let doctorViewModel = DoctorViewModel(nombre: doctor.name.capitalizedString, especialidad: doctor.especialidad.capitalizedString)
                
                var firstLetterOfDoctor = String(doctor.name[doctor.name.startIndex])
                
                firstLetterOfDoctor = firstLetterOfDoctor.capitalizedString
                
                if let doctorsByLetter = self.doctorsGroupedAlphabetically[firstLetterOfDoctor] {
                   self.doctorsGroupedAlphabetically[firstLetterOfDoctor] = doctorsByLetter + [doctorViewModel]
                } else {
                    self.doctorsGroupedAlphabetically[firstLetterOfDoctor] = [doctorViewModel]
                }
                
                if !self.letters.contains(firstLetterOfDoctor.capitalizedString) {
                    self.letters.append(firstLetterOfDoctor.capitalizedString)
                }
                
                if !self.specialties.contains(doctor.especialidad.capitalizedString) {
                    self.specialties.append(doctor.especialidad.capitalizedString)
                }
            }
            
            // Sort all keys in the doctors dictionary.
            self.letters = self.doctorsGroupedAlphabetically.keys.sort()
            
            // Sort all [DoctorViewModel]
            for (key, doctors) in self.doctorsGroupedAlphabetically {
                self.doctorsGroupedAlphabetically[key] = doctors.sort { $0.name < $1.name }
            }
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
            }
        }
        
        return notificationName
    }
    
    /**
     Compares if there are doctors to match the query
     
     - parameter query: the query typed in the search bar
     */
    func temporarySearchedDoctors(query query: String?) {
        
        lettersForFilteredDoctors = nil
        doctorsWhenSearching = nil
        
        if let userQuery = query {
            var queriedDoctors = [String: [DoctorViewModel]]()
            lettersForFilteredDoctors = [String]()
            for (key, doctors) in doctorsGroupedAlphabetically {
                let filteredArray = doctors.filter { $0.name.lowercaseString.containsString(userQuery.lowercaseString) }
                guard !filteredArray.isEmpty else { continue }
                
                queriedDoctors[key] = filteredArray
                if !lettersForFilteredDoctors!.contains(key) {
                    lettersForFilteredDoctors!.append(key)
                }
            }

            doctorsWhenSearching = queriedDoctors
        }
        
    }
}