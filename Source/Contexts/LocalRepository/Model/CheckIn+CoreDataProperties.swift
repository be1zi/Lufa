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

// MARK: ManagedObject override
extension CheckIn {
    
    override func primaryKey() -> String? {
        return "flightDesignator"
    }
    
    override func serialize(data: [String : Any]) {
        
        self.flightDesignator = data["flightDesignator"] as? String
        self.flightDate = data["flightDate"] as? NSDate
        self.departureAirport = data["departureAirport"] as? String
        self.arrivalAirport = data["arrivalAirport"] as? String
        self.briefingRoom = data["briefingRoom"] as? String
        self.briefingBegin = data["arrivalAirport"] as? String
        self.crewAtSecurityCheck = data["crewAtSecurityCheck"] as? NSDate
        self.crewBusDeparture = data["crewBusDeparture"] as? NSDate
        self.readinessNotification = data["readinessNotification"] as? NSDate
        self.boardingBegin = data["boardingBegin"] as? NSDate
        self.paxOnBoard = data["paxOnBoard"] as? NSDate
    }
}
