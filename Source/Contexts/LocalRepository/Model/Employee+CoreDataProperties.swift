//
//  Employee+CoreDataProperties.swift
//  Lufa
//
//  Created by Konrad Belzowski on 11/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var pkNumber: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var crewPosition: String?
    @NSManaged public var dutyCode: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var birthDate: Date?
}

// MARK: ManagedObject override
extension Employee {
    
    override func primaryKey() -> String? {
        return "pkNumber"
    }
    
    override func serialize(data: [String : Any]) {
        
        self.pkNumber = data["pkNumber"] as? String
        self.firstName = data["firstName"] as? String
        self.lastName = data["lastName"] as? String
        self.crewPosition = data["crewPosition"] as? String
        self.dutyCode = data["dutyCode"] as? String
        self.email = data["email"] as? String
        self.phone = data["phone"] as? String
        self.birthDate = self.addDateProperty(date: data["birthDate"])
    }
}

extension Employee {
    
    func fullName() -> String {
        
        let firstName = self.firstName ?? ""
        let lastName = self.lastName ?? ""
        
        return "\(firstName) \(lastName)"
    }
}
