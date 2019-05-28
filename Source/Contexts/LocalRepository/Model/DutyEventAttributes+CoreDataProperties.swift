//
//  DutyEventAttributes+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/05/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData

extension DutyEventAttributes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DutyEventAttributes> {
        return NSFetchRequest<DutyEventAttributes>(entityName: "DutyEventAttributes")
    }

    @NSManaged public var key: String?
    @NSManaged public var value: String?
    @NSManaged public var dutyEvent: DutyEvent?

}
