//
//  Crew+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/05/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData

extension Crew {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Crew> {
        return NSFetchRequest<Crew>(entityName: "Crew")
    }

    @NSManaged public var flightDesignator: String?
    @NSManaged public var flightDate: NSDate?
    @NSManaged public var departureAirport: String?
    @NSManaged public var arrivalAirport: String?
    @NSManaged public var crewMembers: NSSet?
}

// MARK: Generated accessors for crewMembers
extension Crew {

    @objc(addCrewMembersObject:)
    @NSManaged public func addToCrewMembers(_ value: CrewMember)

    @objc(removeCrewMembersObject:)
    @NSManaged public func removeFromCrewMembers(_ value: CrewMember)

    @objc(addCrewMembers:)
    @NSManaged public func addToCrewMembers(_ values: NSSet)

    @objc(removeCrewMembers:)
    @NSManaged public func removeFromCrewMembers(_ values: NSSet)
}

// MARK: ManagedObject override
extension Crew {
    
    override func primaryKey() -> String? {
        return "flightDesignator"
    }
    
    override func serialize(data: [String : Any]) {
        
        self.flightDesignator = data["flightDesignator"] as? String
        self.flightDate = data["flightDate"] as? NSDate
        self.departureAirport = data["departureAirport"] as? String
        self.arrivalAirport = data["arrivalAirport"] as? String
        
        guard let key = self.flightDesignator else {
            return
        }
        
        if let crewMembers = data["crewMembers"] as? [[String: Any]] {
            self.addToCrewMembers(addRelationship(data: crewMembers,
                                                  forProperty: "crewMembers" ,
                                                  entityName: "CrewMember",
                                                  rootEntityName: "Crew",
                                                  rootPrimeryKeyValue: key))
            
        } else if let crewMembers = data["crewMembers"] as? [String:Any] {
            self.addToCrewMembers(addRelationship(data: [crewMembers],
                                                  forProperty: "crewMembers",
                                                  entityName: "CrewMember",
                                                  rootEntityName: "Crew",
                                                  rootPrimeryKeyValue: key))
        }
    }
}
