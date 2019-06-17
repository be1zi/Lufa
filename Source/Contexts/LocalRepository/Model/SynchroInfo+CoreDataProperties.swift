//
//  SynchroInfo+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 17/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData

enum SynchroType: Int {
    case SynchroTypeCountries
}

extension SynchroInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SynchroInfo> {
        return NSFetchRequest<SynchroInfo>(entityName: "SynchroInfo")
    }

    @NSManaged public var lastSynchroDate: Date?
    @NSManaged public var object: String?
    @NSManaged public var synchroType: Int64

}

extension SynchroInfo {
    
    override func primaryKey() -> String? {
        return "object"
    }
    
    override func serialize(data: [String : Any]) {
        
        self.lastSynchroDate = self.addDateProperty(date: Date.init())
        self.object = data["object"] as? String
        self.synchroType = data["synchroType"] as? Int64 ?? 0
    }
}
