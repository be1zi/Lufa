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
        return getFlights(limit: nil, date: nil)
    }
    
    func getTodayFlights() -> [Flight]? {
        return getFlights(limit: nil, date: Date.init())
    }
    
    private func getFlights(limit: Int?, date: Date?) -> [Flight]? {
        
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
        
        if let date = date {
            if let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date),
                let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date) {
                request.predicate = NSPredicate(format: "flightDesignator IN %@ and flightDate >= %@ and flightDate < %@", argumentArray: [designators, startDate, endDate])
            } else {
                request.predicate = NSPredicate(format: "flightDesignator IN %@ and flightDate >= %@", argumentArray: [designators, Date.init()])
            }
        } else {
            request.predicate = NSPredicate(format: "flightDesignator IN %@ and flightDate >= %@", argumentArray: [designators, Date.init()])
        }
        
        request.sortDescriptors = [NSSortDescriptor.init(key: "flightDate", ascending: true)]
        
        return self.executeFetch(fetchRequest: request) as? [Flight]
    }
}
