//
//  CrewFlight+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/05/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData

extension CrewFlight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CrewFlight> {
        return NSFetchRequest<CrewFlight>(entityName: "CrewFlight")
    }

    @NSManaged public var flightDesignator: String?
    @NSManaged public var flightDate: NSDate?
    @NSManaged public var legSequenceNo: Int32
    @NSManaged public var dutyCode: String?
    @NSManaged public var exFlight: CrewMember?
    @NSManaged public var toFlight: CrewMember?

}