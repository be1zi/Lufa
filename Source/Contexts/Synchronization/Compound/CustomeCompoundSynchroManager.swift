//
//  CustomeCompoundSynchroManager.swift
//  Lufa
//
//  Created by Konrad Belzowski on 11/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

class CustomeCompoundSynchroManager: CompoundSynchroManager {
    
    static let sharedInstance = CustomeCompoundSynchroManager(withManagers: [])
    
    func loadWithManagers(types: [SynchroType]) {
        
        var localManagers: [SynchroManager] = []
        
        for type in types {
            switch type {
            case .Airline:
                localManagers.append(AirlineSynchroManager.sharedInstance)
            case .Cities:
                localManagers.append(CitySynchroManager.sharedInstance)
            case .Countries:
                localManagers.append(CountrySynchroManager.sharedInstance)
            case .Crew:
                localManagers.append(CrewSynchroManager.sharedInstance)
            case .Flights:
                localManagers.append(FlightSynchroManager.sharedInstance)
            default:
                continue
            }
        }
        
        self.managers = localManagers
    }
}
