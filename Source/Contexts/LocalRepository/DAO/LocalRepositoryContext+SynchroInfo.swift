//
//  LocalRepositoryContext+SynchroInfo.swift
//  Lufa
//
//  Created by Konrad Belzowski on 17/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import CoreData

extension LocalRepositoryContext {
    
    private func timeIntervalForSynchroType(synchroType: SynchroType) -> TimeInterval {
        
        switch synchroType {
        case .SynchroTypeCountries:
            return 6 * 30 * 24 * 60 * 60 // every six months
        case .SynchroTypeCities:
            return 6 * 30 * 24 * 60 * 60
        }
    }
    
    func shouldSynchronize(synchroType: SynchroType, object: String) -> Bool {
        
        let maxTimeInterval: TimeInterval = timeIntervalForSynchroType(synchroType: synchroType)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SynchroInfo")
        request.predicate = NSPredicate(format: "synchroType = %@ && object = %@", argumentArray: [synchroType.rawValue, object])
        
        let result = self.executeFetch(fetchRequest: request)
        
        if !(result.count > 0) {
            return true
        }
        
        guard let synchroInfo = result.first as? SynchroInfo else {
            return true
        }
        
        guard let lastSynchro = synchroInfo.lastSynchroDate else {
            return true
        }
        
        let currentTimeInterval = Date().timeIntervalSince(lastSynchro)
        
        if currentTimeInterval < maxTimeInterval {
            return false
        } else {
            return true
        }
    }
    
    func notifyDidSynchronize(synchroType: SynchroType, object: String) {
        
        let data: [String : Any] = ["synchroType" : synchroType,
                                    "object" : object]
        
        self.parseAndSave(data: data, name: "SynchroInfo")
    }
}
