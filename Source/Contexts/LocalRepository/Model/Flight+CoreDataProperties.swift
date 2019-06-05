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
    @NSManaged public var flightDate: NSDate?
    @NSManaged public var departureAirport: String?
    @NSManaged public var arrivalAirport: String?
    @NSManaged public var scheduledTimeOfDeparture: NSDate?
    @NSManaged public var scheduledTimeOfArrival: NSDate?
    @NSManaged public var aircraftSubtype: String?
    @NSManaged public var departureGate: String?
    @NSManaged public var departurePosition: String?
    @NSManaged public var arrivalGate: String?
    @NSManaged public var arrivalPosition: String?
    @NSManaged public var flightTime: String?

}

//MAKR: Serialize
extension Flight {
    
    override func serialize(data: [String : Any]) {
        
        self.flightDesignator = data["flightDesignator"] as? String
        self.operatingAirline = data["flightDesignator"] as? String
        self.flightDate = data["flightDesignator"] as? NSDate
        self.departureAirport = data["flightDesignator"] as? String
        self.arrivalAirport = data["flightDesignator"] as? String
        self.scheduledTimeOfDeparture = data["flightDesignator"] as? NSDate
        self.scheduledTimeOfArrival = data["flightDesignator"] as? NSDate
        self.aircraftSubtype = data["flightDesignator"] as? String
        self.departureGate = data["flightDesignator"] as? String
        self.departurePosition = data["flightDesignator"] as? String
        self.arrivalGate = data["flightDesignator"] as? String
        self.arrivalPosition = data["flightDesignator"] as? String
        self.flightTime = data["flightDesignator"] as? String
    }
}
