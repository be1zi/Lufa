//
//  LocalRepositoryContext+Crew.swift
//  Lufa
//
//  Created by Konrad Belzowski on 07/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import CoreData

extension LocalRepositoryContext {
    
    func getCrewForFlight(flightDesignator: String) -> Crew? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Crew")
        request.predicate = NSPredicate(format: "flightDesignator = %@" , flightDesignator)
        request.fetchLimit = 1
        
        return self.executeFetch(fetchRequest: request).first as? Crew
    }
    
    func getFlightDesignatorForCrewMember(employeeID: String) -> [String]? {
        
        let result: [String]?
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Crew")
        request.predicate = NSPredicate(format: "crewMembers.pkNumber = %@" , employeeID)

        let fetchResult = self.executeFetch(fetchRequest: request) as? [Crew]
        
        if let fetchResult = fetchResult {
            
            result = []
            
            for element in fetchResult {
                if let designator = element.flightDesignator {
                    result?.append(designator)
                }
            }
            
            return result
        }
        
        return nil
    }
}
