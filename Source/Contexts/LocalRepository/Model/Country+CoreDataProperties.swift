//
//  Country+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 10/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var code: String?
    @NSManaged public var name: String?
}

// MARK: ManagedObject override
extension Country {
    
    override func primaryKey() -> String? {
        return "code"
    }
    
    override func serialize(data: [String : Any]) {
        
        self.code = data["code"] as? String
        self.name = data["name"] as? String
    }
}
