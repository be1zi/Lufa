//
//  LocalRepositoryContext+Employee.swift
//  Lufa
//
//  Created by Konrad Belzowski on 11/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import CoreData

extension LocalRepositoryContext {
    
    func getEmployee() -> Employee? {
    
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        request.fetchLimit = 1
        
        return self.executeFetch(fetchRequest: request).first?.unmanagedCopy() as? Employee
    }
    
    func updateEmployee(withData data: [String: Any], permissions: [[String: Any]]) {
        
        let context = LocalRepositoryContext.context
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")        
        let emp = self.executeFetch(fetchRequest: request).first as? Employee
        
        guard let employee = emp else {
            return
        }
        
        if let firstName = data["firstName"] as? String {
            employee.firstName = firstName
        }
        
        if let lastName = data["lastName"] as? String {
            employee.lastName = lastName
        }
        
        if let birthDate = data["birthDate"] as? Date {
            employee.birthDate = birthDate
        }
        
        if let email = data["email"] as? String {
            employee.email = email
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "EmployeePermission", in: context) else {
            return
        }
        
        for item in permissions {
        
            if let type = item["name"] as? String,
                let value = item["value"] as? Bool {
                
                if type == PermissionType.AutoSynchronization.rawValue {
                    
                    if let autoSynchronize = LocalRepositoryContext.sharedInstance.getPermission(withName: .AutoSynchronization) {
                        autoSynchronize.value = value
                    } else {
                        let object = NSManagedObject(entity: entity, insertInto: context) as? EmployeePermission
                        object?.name = type
                        object?.value = value
                    }
                    
                } else if type == PermissionType.Notifications.rawValue {
                    
                    if let notifications = LocalRepositoryContext.sharedInstance.getPermission(withName: .Notifications) {
                        notifications.value = value
                    } else {
                        let object = NSManagedObject(entity: entity, insertInto: context) as? EmployeePermission
                        object?.name = type
                        object?.value = value
                    }
                }
            }
        }
        
        self.executeUpdate()
    }
}
