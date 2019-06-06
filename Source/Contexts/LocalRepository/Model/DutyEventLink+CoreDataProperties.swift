//
//  DutyEventLink+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/05/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData

extension DutyEventLink {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DutyEventLink> {
        return NSFetchRequest<DutyEventLink>(entityName: "DutyEventLink")
    }

    @NSManaged public var key: String?
    @NSManaged public var uri: URL?
    @NSManaged public var dutyEvent: DutyEvent?
}

// MARK: ManagedObject override
extension DutyEventLink {
    
    override func primaryKey() -> String? {
        return key
    }
    
    override func serialize(data: [String : Any]) {
        self.key = data.keys.first
        
        if let key = self.key {
            self.uri = data[key] as? URL
        }
    }
}
