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
    @NSManaged public var flightDate: Date?
    @NSManaged public var departureAirport: String?
    @NSManaged public var arrivalAirport: String?
    @NSManaged public var briefingRoom: String?
    @NSManaged public var briefingBegin: String?
    @NSManaged public var crewAtSecurityCheck: Date?
    @NSManaged public var crewBusDeparture: Date?
    @NSManaged public var readinessNotification: Date?
    @NSManaged public var boardingBegin: Date?
    @NSManaged public var paxOnBoard: Date?

}

// MARK: ManagedObject override
extension CheckIn {
    
    override func primaryKey() -> String? {
        return "flightDesignator"
    }
    
    override func serialize(data: [String : Any]) {
        
        self.flightDesignator = data["flightDesignator"] as? String
        self.flightDate = self.addDateProperty(date: data["flightDate"])
        self.departureAirport = data["departureAirport"] as? String
        self.arrivalAirport = data["arrivalAirport"] as? String
        self.briefingRoom = data["briefingRoom"] as? String
        self.briefingBegin = data["arrivalAirport"] as? String
        self.crewAtSecurityCheck =  self.addDateProperty(date: data["crewAtSecurityCheck"])
        self.crewBusDeparture = self.addDateProperty(date: data["crewBusDeparture"])
        self.readinessNotification = self.addDateProperty(date: data["readinessNotification"])
        self.boardingBegin = self.addDateProperty(date: data["boardingBegin"])
        self.paxOnBoard = self.addDateProperty(date: data["paxOnBoard"])
    }
}
