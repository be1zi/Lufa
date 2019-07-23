//
//  EmployeePermission+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 09/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData

extension EmployeePermission {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeePermission> {
        return NSFetchRequest<EmployeePermission>(entityName: "EmployeePermission")
    }

    @NSManaged public var name: String?
    @NSManaged public var value: Bool
}

// MARK: ManagedObject override
extension EmployeePermission {
    
    override func primaryKey() -> String? {
        return "name"
    }
    
    override func serialize(data: [String: Any]) {
        self.name = data["name"] as? String
        
        if let value = data["value"] as? Bool {
            self.value = value
        }
    }
}
