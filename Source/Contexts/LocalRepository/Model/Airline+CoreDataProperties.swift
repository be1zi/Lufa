//
//  Airline+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData

extension Airline {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Airline> {
        return NSFetchRequest<Airline>(entityName: "Airline")
    }

    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var codeICAO: String?
}

extension Airline {
    
    override func primaryKey() -> String? {
        return "code"
    }
    
    override func serialize(data: [String: Any]) {
        
        self.code = data["code"] as? String
        self.name = data["name"] as? String
        self.codeICAO = data["codeICAO"] as? String
    }
}
