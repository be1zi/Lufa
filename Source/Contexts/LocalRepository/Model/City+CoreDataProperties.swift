//
//  City+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 10/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var code: String?
    @NSManaged public var countryCode: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
}

// MARK: ManagedObject override
extension City {
    
    override func primaryKey() -> String? {
        return "code"
    }
    
    override func serialize(data: [String : Any]) {
        
        self.code = data["code"] as? String
        self.name = data["name"] as? String
        self.countryCode = data["countryCode"] as? String
        
        if let latitude = data["latitude"] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = data["longitude"] as? Double {
            self.longitude = longitude
        }
    }
}
