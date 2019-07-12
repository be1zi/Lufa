//
//  LocalRepositoryContext+CheckIn.swift
//  Lufa
//
//  Created by Konrad Belzowski on 05/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import CoreData

extension LocalRepositoryContext {
    
    func getAllCheckIn() -> [CheckIn]? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CheckIn")
        
        return self.executeFetch(fetchRequest: request).unmanagedCopy() as? [CheckIn]
    }
}
