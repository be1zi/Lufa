//
//  CitySynchroManager.swift
//  Lufa
//
//  Created by Konrad Belzowski on 17/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

class CitySynchroManager: SynchroManager {
    
    //MARK: Singleton
    static let sharedInstance = CitySynchroManager()
    
    override func synchronizeWithCompletion(completion: SynchroCompletion?, forced: Bool) {
        
        super.synchronizeWithCompletion(completion: completion, forced: forced)
        
        if synchroInProgress {
            return
        }
        
        if !forced {
            
            if !RemoteRepositoryContext.sharedInstance.isReachable() {
                self.notifyCompletionsWithResult(result: .SynchroResultSkipped, error: nil)
                return
            }
            
            if !LocalRepositoryContext.sharedInstance.shouldSynchronize(synchroType: .SynchroTypeCities, object: "City") {
                self.notifyCompletionsWithResult(result: .SynchroResultSkipped, error: nil)
                return
            }
        }
        
        self.synchroInProgress = true
        var localError: Error?
        
        let group: DispatchGroup = DispatchGroup()
        
        group.enter()
        RemoteRepositoryContext.sharedInstance.getAllCities(withOffset: 0, result: [], withSuccess: { _ in
            group.leave()
        }) { error in
            localError = error
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.synchroInProgress = false
            
            let synchroResult = localError != nil ? SynchroResult.SynchroResultError : SynchroResult.SynchroResultOK
            
            if synchroResult == SynchroResult.SynchroResultOK {
                
                LocalRepositoryContext.sharedInstance.notifyDidSynchronize(synchroType: .SynchroTypeCities, object: "City")
            }
            
            self.notifyCompletionsWithResult(result: synchroResult, error: localError)
        }
    }
}