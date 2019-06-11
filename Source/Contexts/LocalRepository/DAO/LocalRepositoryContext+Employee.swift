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
        
        return self.executeFetch(fetchRequest: request).first as? Employee
    }
}
