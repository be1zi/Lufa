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
