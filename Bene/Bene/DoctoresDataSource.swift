//
//  Doctores.swift
//  Bene
//
//  Created by David Mar Alvarez on 6/24/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import Foundation

struct Doctor {
    let name: String
    let especialidad: String
}

class DoctoresDataSource {

    /**
     Asynchronously returns the list of doctors from our backing store.

     - parameter completionBlock
     */
    func fetchDoctores(completionBlock: [Doctor] -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let premadeDoctors = [
                Doctor(name: "Juan Robles", especialidad: "Cardiología"),
                Doctor(name: "Pedro Sánchez", especialidad: "Cardiología"),
                Doctor(name: "Francisco Márquez", especialidad: "Cardiología"),
                Doctor(name: "Dolores Haze", especialidad: "Otorrinolaringología"),
                Doctor(name: "Mariana Vázquez", especialidad: "Oncología"),
                Doctor(name: "Josefa Guerrero", especialidad: "Oncología"),
                Doctor(name: "Raquel Manzur", especialidad: "Reumatismo"),
                Doctor(name: "Jorge Martínez", especialidad: "Reumatismo"),
                Doctor(name: "Carlos Vela", especialidad: "Reumatismo"),
                Doctor(name: "Mario González", especialidad: "Reumatismo")
            ]

            completionBlock(premadeDoctors)
        }
    }
    
}
