//
//  LocalRepositoryContext+City.swift
//  Lufa
//
//  Created by Konrad Belzowski on 14/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import CoreData

extension LocalRepositoryContext {
    
    func getCityName(shortCut: String?) -> City? {
        
        guard let shortCut = shortCut else {
            return nil
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        request.predicate = NSPredicate(format: "code = %@", shortCut)
        
        return self.executeFetch(fetchRequest: request).first?.unmanagedCopy() as? City
    }
}
