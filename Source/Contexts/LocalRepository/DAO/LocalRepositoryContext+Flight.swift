//
//  LocalRepositoryContext+Flight.swift
//  Lufa
//
//  Created by Konrad Belzowski on 11/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import CoreData

extension LocalRepositoryContext {
    
    func getAllFlights() -> [Flight]? {
        return getFlights(limit: nil)
    }
    
    func getFlights(limit: Int?) -> [Flight]? {
        
        let emp = getEmployee()
        
        guard let employee = emp else {
            return nil
        }
        
        guard let pk = employee.pkNumber else {
            return nil
        }
        
        let flightDesignators = getFlightDesignatorForCrewMember(employeeID: pk)

        guard let designators = flightDesignators else {
            return nil
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Flight")
        request.predicate = NSPredicate(format: "flightDesignator IN %@", designators)
        
        return self.executeFetch(fetchRequest: request) as? [Flight]
    }
    
//    func getEmployee() -> Employee? {
//
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
//        request.fetchLimit = 1
//
//        return self.executeFetch(fetchRequest: request).first as? Employee
//    }
    
}
