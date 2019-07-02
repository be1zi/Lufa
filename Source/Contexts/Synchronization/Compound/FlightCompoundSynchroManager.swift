//
//  FlightCompoundSynchroManager.swift
//  Lufa
//
//  Created by Konrad Belzowski on 02/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

class FlightCompoundSynchroManager: CompoundSynchroManager {
    
    //MARK: - Singleton
    static let sharedInstance = FlightCompoundSynchroManager(withManagers: [])
    
    override init(withManagers: [SynchroManager]) {
        super.init(withManagers: [FlightSynchroManager.sharedInstance,
                                  CrewSynchroManager.sharedInstance])
    }
    
}
