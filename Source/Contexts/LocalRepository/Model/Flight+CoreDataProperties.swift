//
//  Flight+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/05/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData

extension Flight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flight> {
        return NSFetchRequest<Flight>(entityName: "Flight")
    }

    @NSManaged public var flightDesignator: String?
    @NSManaged public var operatingAirline: String?
    @NSManaged public var flightDate: Date?
    @NSManaged public var departureAirport: String?
    @NSManaged public var arrivalAirport: String?
    @NSManaged public var scheduledTimeOfDeparture: Date?
    @NSManaged public var scheduledTimeOfArrival: Date?
    @NSManaged public var aircraftSubtype: String?
    @NSManaged public var departureGate: String?
    @NSManaged public var departurePosition: String?
    @NSManaged public var arrivalGate: String?
    @NSManaged public var arrivalPosition: String?
    @NSManaged public var flightTime: String?
    @NSManaged public var lastViewed: Date?

}

// MARK: ManagedObject override
extension Flight {
    
    override func primaryKey() -> String? {
        return "flightDesignator"
    }
    
    override func serialize(data: [String: Any]) {
        
        self.flightDesignator = data["flightDesignator"] as? String
        self.operatingAirline = data["operatingAirline"] as? String
        self.flightDate = self.addDateProperty(date: data["flightDate"])
        self.departureAirport = data["departureAirport"] as? String
        self.arrivalAirport = data["arrivalAirport"] as? String
        self.scheduledTimeOfDeparture = self.addDateProperty(date: data["scheduledTimeOfDeparture"])
        self.scheduledTimeOfArrival = self.addDateProperty(date: data["scheduledTimeOfArrival"])
        self.aircraftSubtype = data["aircraftSubtype"] as? String
        self.departureGate = data["departureGate"] as? String
        self.departurePosition = data["departurePosition"] as? String
        self.arrivalGate = data["arrivalGate"] as? String
        self.arrivalPosition = data["arrivalPosition"] as? String
        self.flightTime = data["flightTime"] as? String
    }
}
