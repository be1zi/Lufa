//
//  InitSynchroManager.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

class InitCompoundSynchroManager: CompoundSynchroManager {
    
    //MARK: - Singleton
    static var sharedInstance = InitCompoundSynchroManager(withManagers: [])
    
    override init(withManagers: [SynchroManager]) {
        super.init(withManagers: [CountrySynchroManager.sharedInstance,
                                  CitySynchroManager.sharedInstance,
                                  AirlineSynchroManager.sharedInstance,
                                  FlightSynchroManager.sharedInstance])
    }
}
