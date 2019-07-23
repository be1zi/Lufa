//
//  CompoundSynchroManager.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

class CompoundSynchroManager: SynchroManager {
    
    var managers: [SynchroManager] = []
    
    init(withManagers: [SynchroManager]) {        
        self.managers = withManagers
    }
    
    override func synchronizeWithCompletion(completion: SynchroCompletion?, forced: Bool) {
        
        super.synchronizeWithCompletion(completion: completion, forced: forced)
        
        if self.synchroInProgress {
            return
        }
        
        if self.managers.count < 1 {
        
            self.notifyCompletionsWithResult(result: .SynchroResultSkipped, error: nil)
        }
        
        if !RemoteRepositoryContext.sharedInstance.isReachable() {
            self.notifyCompletionsWithResult(result: .SynchroResultSkipped, error: nil)
        }
        
        self.synchroInProgress = true
        
        var allSkipped = true
        var localError: Error?
        let group: DispatchGroup = DispatchGroup()
        
        for manager in managers {
            
            group.enter()
            manager.synchronizeWithCompletion(completion: { result, error in
                
                if error != nil && localError == nil {
                    localError = error
                }
                
                if result != SynchroResult.SynchroResultSkipped {
                    allSkipped = false
                }
                
                group.leave()
                
            }, forced: forced)
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.synchroInProgress = false
            
            var result: SynchroResult = .SynchroResultOK
            if allSkipped {
                result = .SynchroResultSkipped
            } else if localError != nil {
                result = .SynchroResultError
            }
            
            self.notifyCompletionsWithResult(result: result, error: localError)
        }
    }
}
