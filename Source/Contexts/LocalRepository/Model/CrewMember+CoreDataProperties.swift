//
//  CrewMember+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/05/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData

extension CrewMember {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CrewMember> {
        return NSFetchRequest<CrewMember>(entityName: "CrewMember")
    }

    @NSManaged public var pkNumber: String?
    @NSManaged public var crewPosition: String?
    @NSManaged public var posPrefix: String?
    @NSManaged public var lastName: String?
    @NSManaged public var firstName: String?
    @NSManaged public var courseNumber: Int32
    @NSManaged public var dutyCode: String?
    @NSManaged public var crew: Crew?
    @NSManaged public var exFlight: CrewFlight?
    @NSManaged public var toFlight: CrewFlight?

}

// MARK: ManagedObject override
extension CrewMember {
    
    override func primaryKey() -> String? {
        return "pkNumber"
    }
    
    override func serialize(data: [String: Any]) {
        
        self.pkNumber = data["pkNumber"] as? String
        self.crewPosition = data["crewPosition"] as? String
        self.posPrefix = data["posPrefix"] as? String
        self.lastName = data["lastName"] as? String
        self.firstName = data["firstName"] as? String
        self.courseNumber = data["courseNumber"] as? Int32 ?? 0
        self.dutyCode = data["dutyCode"] as? String
        
        self.exFlight = self.addOneToOneRelationship(data: data["exFlight"], forEntityName: "CrewFlight", forProperty: self.exFlight) as? CrewFlight
        
        self.toFlight = self.addOneToOneRelationship(data: data["toFlight"], forEntityName: "CrewFlight", forProperty: self.toFlight) as? CrewFlight
    }
}
