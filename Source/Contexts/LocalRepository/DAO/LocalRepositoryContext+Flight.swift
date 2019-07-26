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

        let predicate = NSPredicate(format: "\(format) and lastViewed != nil")
        request?.predicate = predicate
        request?.sortDescriptors = [NSSortDescriptor.init(key: "lastViewed", ascending: false)]
        
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
    
    func requestForFlight(withFilters items: [FlightFilterItem]?) -> NSFetchRequest<NSFetchRequestResult>? {
        
        let request = getAllFlights()
        
        guard let items = items,
            let format = request?.predicate?.predicateFormat else {
            return request
        }
        
        var predicatesArray = [String]()
        var extendedFormat = ""
        
        for item in items {
            
            switch item.type {
            case .date:
                if let value = item.values[.min] {
                    predicatesArray.append("flightDate >= \(value)")
                }
                
                if let value = item.values[.max] {
                    predicatesArray.append("flightDate <= \(value)")
                }
            case .place:
                if let value = item.values[.min] {
                    predicatesArray.append("departureAirport = \(value)")
                }
                
                if let value = item.values[.max] {
                    predicatesArray.append("arrivalAirport = \(value)")
                }
            case .travelTime:
                if let min = item.values[.min] as? Float, let max = item.values[.max] as? Float {
                    predicatesArray.append("flightTime >= \(min * 60 * 1000) and flightTime <= \(max * 60 * 1000)")
                }
            case .type:
                continue
            case .unknown:
                continue
            }
        }
        
        for (index, item) in predicatesArray.enumerated() {
            
            extendedFormat += item
            
            if index != (predicatesArray.count - 1) {
                extendedFormat += " and "
            }
        }
        
        if extendedFormat.count > 0 {
            let predicate = NSPredicate(format: "\(format) and \(extendedFormat)")
            request?.predicate = predicate
        }
        
        guard let req = request else {
            return request
        }
        
        let result = self.executeFetch(fetchRequest: req) as? [Flight]
        
        guard var res = result else {
            return req
        }
        
        for item in items {
            if item.type != .type {
                continue
            }
            
            if let value = item.values[.value] as? String {
                if value == "flight.filters.type.local.title" {
                    res = res.filter {
                        LocalRepositoryContext.sharedInstance.isCitiesInSameCountry(cityACode: $0.departureAirport, cityBCode: $0.arrivalAirport)
                    }
                } else if value == "flight.filters.type.international.title" {
                    res = res.filter {
                        !LocalRepositoryContext.sharedInstance.isCitiesInSameCountry(cityACode: $0.departureAirport, cityBCode: $0.arrivalAirport)
                    }
                }
                break
            }
        }
        
        let flightDesignators = res.map { $0.flightDesignator }
       
        if let currentPredicateFormat = req.predicate?.predicateFormat {
            req.predicate = NSPredicate(format: "\(currentPredicateFormat) and flightDesignator IN %@", flightDesignators)
        }
        
        return req
    }
    
    func setFlightAsViewed(key: String?) {
        
        guard let key = key else {
            return
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Flight")
        request.predicate = NSPredicate(format: "flightDesignator = %@", key)
        
        if let flight = self.executeFetch(fetchRequest: request).first as? Flight {
            flight.lastViewed = Date.init()
            
            self.executeUpdate()
        }
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
