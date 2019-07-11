//
//  CrewSynchroManager.swift
//  Lufa
//
//  Created by Konrad Belzowski on 02/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

class CrewSynchroManager: SynchroManager {
    
    //MARK: - Singleton
    static let sharedInstance = CrewSynchroManager()
    
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
            
            if !LocalRepositoryContext.sharedInstance.shouldSynchronize(synchroType: .Crew, object: String(describing: Crew.self)) {
                self.notifyCompletionsWithResult(result: .SynchroResultSkipped, error: nil)
                return
            }
            
            if let employee = LocalRepositoryContext.sharedInstance.getEmployee(),
                !employee.autoSynchronizationEnabled() {
                self.notifyCompletionsWithResult(result: .SynchroResultSkipped, error: nil)
                return
            }
        }
        
        self.synchroInProgress = true
        var localError: Error?
        
        let group: DispatchGroup = DispatchGroup()
        
        group.enter()
        RemoteRepositoryContext.sharedInstance.getAllCrew(withSuccess: { _ in
            group.leave()
        }) { error in
            localError = error
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.synchroInProgress = false
            
            let synchroResult: SynchroResult = localError != nil ? .SynchroResultError : .SynchroResultOK
            
            if synchroResult == SynchroResult.SynchroResultOK {
                LocalRepositoryContext.sharedInstance.notifyDidSynchronize(synchroType: .Crew, object: String(describing: Crew.self))
            }
            
            self.notifyCompletionsWithResult(result: synchroResult, error: localError)
        }
    }
}
