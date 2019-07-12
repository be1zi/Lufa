//
//  LocalRepositoryContext+EmployeePermission.swift
//  Lufa
//
//  Created by Konrad Belzowski on 09/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import CoreData

enum PermissionType: String {
    case AutoSynchronization
    case Notifications
}

extension LocalRepositoryContext {
    
    func getPermission(withName name: PermissionType) -> EmployeePermission? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeePermission")
        request.predicate = NSPredicate(format: "name = %@", name.rawValue)
        request.fetchLimit = 1
        
        return self.executeFetch(fetchRequest: request).first?.unmanagedCopy() as? EmployeePermission
    }
}
