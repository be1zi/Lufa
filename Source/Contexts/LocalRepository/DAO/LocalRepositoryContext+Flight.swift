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
    
    func requestForLastViewedFlights() -> NSFetchRequest<NSFetchRequestResult>? {
        
        let request = getAllFlights()
        
        guard let format = request?.predicate?.predicateFormat else {
            return request
        }

        let predicate = NSPredicate(format: "\(format) and lastViewed = %d", true)
        request?.predicate = predicate
        
        return request
    }
    
    func requestForFlight(withText text: String?) -> NSFetchRequest<NSFetchRequestResult>? {
        
        let request = getAllFlights()
        
        guard let format = request?.predicate?.predicateFormat, let text = text else {
            return request
        }
        
        let predicate = NSPredicate(format: "\(format) and flightDesignator CONTAINS[CD] %@", text)
        request?.predicate = predicate
        
        return request
    }
    
    func getAllFlights() -> NSFetchRequest<NSFetchRequestResult>? {
        return getFlights(date: nil)
    }
    
    func getTodayFlights() -> NSFetchRequest<NSFetchRequestResult>? {
        return getFlights(date: Date.init())
    }
    
    private func getFlights(date: Date?) -> NSFetchRequest<NSFetchRequestResult>? {
        
        let emp = getEmployee()
        var localDate = Date.init()
        
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
            localDate = date
        }
        
        guard let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: localDate),
            let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: localDate) else {
            return nil
        }
        
        if date != nil {
            request.predicate = NSPredicate(format: "flightDesignator IN %@ and flightDate >= %@ and flightDate < %@", argumentArray: [designators, startDate, endDate])
        } else {
            request.predicate = NSPredicate(format: "flightDesignator IN %@ and flightDate >= %@", argumentArray: [designators, startDate])
        }
        
        request.sortDescriptors = [NSSortDescriptor.init(key: "flightDate", ascending: true)]
        
        return request
    }
}
