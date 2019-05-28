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
    @NSManaged public var eventDefails: String?
    @NSManaged public var wholeDay: Bool
    @NSManaged public var startTime: NSDate?
    @NSManaged public var startLocation: String?
    @NSManaged public var startTimeZoneOffset: Int32
    @NSManaged public var endTime: NSDate?
    @NSManaged public var endLocation: String?
    @NSManaged public var endTimeZoneOffset: Int32
    @NSManaged public var dutyDay: DutyDay?
    @NSManaged public var attributes: NSSet?
    @NSManaged public var dutyLinks: NSSet?
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
