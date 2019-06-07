//
//  Duty+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/05/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData

extension Duty {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Duty> {
        return NSFetchRequest<Duty>(entityName: "Duty")
    }

    @NSManaged public var pkNumber: String?
    @NSManaged public var fromDate: NSDate?
    @NSManaged public var toDate: NSDate?
    @NSManaged public var dutyDays: Set<NSManagedObject>
}

// MARK: Generated accessors for dutyDays
extension Duty {

    @objc(addDutyDaysObject:)
    @NSManaged public func addToDutyDays(_ value: DutyDay)

    @objc(removeDutyDaysObject:)
    @NSManaged public func removeFromDutyDays(_ value: DutyDay)

    @objc(addDutyDays:)
    @NSManaged public func addToDutyDays(_ values: NSSet)

    @objc(removeDutyDays:)
    @NSManaged public func removeFromDutyDays(_ values: NSSet)
}

// MARK: ManagedObject override
extension Duty {
    
    override func primaryKey() -> String? {
        return "pkNumber"
    }
    
    override func serialize(data: [String : Any]) {
        
        self.pkNumber = data["pkNumber"] as? String
        self.fromDate = data["fromDate"] as? NSDate
        self.toDate = data["toDate"] as? NSDate
        
        self.dutyDays = self.addOneToManyRelationship(data: data["rosterDays"], set: self.dutyDays, forEntityName: "DutyDay")
    }
}
