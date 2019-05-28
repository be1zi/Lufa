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
