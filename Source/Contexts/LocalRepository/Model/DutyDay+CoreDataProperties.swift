//
//  DutyDay+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/05/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData

extension DutyDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DutyDay> {
        return NSFetchRequest<DutyDay>(entityName: "DutyDay")
    }

    @NSManaged public var day: NSDate?
    @NSManaged public var duty: Duty?
    @NSManaged public var dutyEvents: Set<NSManagedObject>
}

// MARK: Generated accessors for dutyEvents
extension DutyDay {

    @objc(addDutyEventsObject:)
    @NSManaged public func addToDutyEvents(_ value: DutyEvent)

    @objc(removeDutyEventsObject:)
    @NSManaged public func removeFromDutyEvents(_ value: DutyEvent)

    @objc(addDutyEvents:)
    @NSManaged public func addToDutyEvents(_ values: NSSet)

    @objc(removeDutyEvents:)
    @NSManaged public func removeFromDutyEvents(_ values: NSSet)
}

// MARK: ManagedObject override
extension DutyDay {
    
    override func primaryKey() -> String? {
        return "day"
    }
    
    override func serialize(data: [String : Any]) {
        
        self.day = data["day"] as? NSDate
        self.dutyEvents = self.addOneToManyRelationship(data: data["events"], set: self.dutyEvents, forEntityName: "DutyEvent")
    }
}
