//
//  DutyEvent+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/05/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData

extension DutyEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DutyEvent> {
        return NSFetchRequest<DutyEvent>(entityName: "DutyEvent")
    }

    @NSManaged public var eventType: String?
    @NSManaged public var eventCategory: String?
    @NSManaged public var eventDetails: String?
    @NSManaged public var wholeDay: Bool
    @NSManaged public var startTime: NSDate?
    @NSManaged public var startLocation: String?
    @NSManaged public var startTimeZoneOffset: Int32
    @NSManaged public var endTime: NSDate?
    @NSManaged public var endLocation: String?
    @NSManaged public var endTimeZoneOffset: Int32
    @NSManaged public var dutyDay: DutyDay?
    @NSManaged public var attributes: Set<NSManagedObject>
    @NSManaged public var dutyLinks: Set<NSManagedObject>
}

// MARK: Generated accessors for attributes
extension DutyEvent {

    @objc(addAttributesObject:)
    @NSManaged public func addToAttributes(_ value: DutyEventAttributes)

    @objc(removeAttributesObject:)
    @NSManaged public func removeFromAttributes(_ value: DutyEventAttributes)

    @objc(addAttributes:)
    @NSManaged public func addToAttributes(_ values: NSSet)

    @objc(removeAttributes:)
    @NSManaged public func removeFromAttributes(_ values: NSSet)
}

// MARK: Generated accessors for dutyLinks
extension DutyEvent {

    @objc(addDutyLinksObject:)
    @NSManaged public func addToDutyLinks(_ value: DutyEventLink)

    @objc(removeDutyLinksObject:)
    @NSManaged public func removeFromDutyLinks(_ value: DutyEventLink)

    @objc(addDutyLinks:)
    @NSManaged public func addToDutyLinks(_ values: NSSet)

    @objc(removeDutyLinks:)
    @NSManaged public func removeFromDutyLinks(_ values: NSSet)
}

// MARK: ManagedObject override
extension DutyEvent {
    
    override func primaryKey() -> String? {
        return "eventDetails"
    }
    
    override func serialize(data: [String : Any]) {
        
        self.eventType = data["eventType"] as? String
        self.eventCategory = data["eventCategory"] as? String
        self.eventDetails = data["eventDetails"] as? String
        self.wholeDay = data["wholeDay"] as? Bool ?? false
        self.startTime = data["startTime"] as? NSDate
        self.startLocation = data["startLocation"] as? String
        self.startTimeZoneOffset = data["startTimeZoneOffset"] as? Int32 ?? 0
        self.endTime = data["endTime"] as? NSDate
        self.endLocation = data["endLocation"] as? String
        self.endTimeZoneOffset = data["endTimeZoneOffset"] as? Int32 ?? 0
        
        self.attributes = self.addOneToManyRelationship(data: data["eventAttributes"], set: self.attributes, forEntityName: "DutyEventAttributes")
        
        self.dutyLinks = self.addOneToManyRelationship(data: data["_links"], set: self.dutyLinks, forEntityName: "DutyEventLink")
    }
}
