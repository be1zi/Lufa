//
//  CheckIn+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/05/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData

extension CheckIn {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckIn> {
        return NSFetchRequest<CheckIn>(entityName: "CheckIn")
    }

    @NSManaged public var flightDesignator: String?
    @NSManaged public var flightDate: NSDate?
    @NSManaged public var departureAirport: String?
    @NSManaged public var arrivalAirport: String?
    @NSManaged public var briefingRoom: String?
    @NSManaged public var briefingBegin: String?
    @NSManaged public var crewAtSecurityCheck: NSDate?
    @NSManaged public var crewBusDeparture: NSDate?
    @NSManaged public var readinessNotification: NSDate?
    @NSManaged public var boardingBegin: NSDate?
    @NSManaged public var paxOnBoard: NSDate?

}
