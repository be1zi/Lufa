//
//  SynchroManager.swift
//  Lufa
//
//  Created by Konrad Belzowski on 17/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

enum SynchroResult {
    case SynchroResultOK
    case SynchroResultSkipped
    case SynchroResultError
}

typealias SynchroCompletion = (SynchroResult, Error?) -> Void

class SynchroManager {
    
    var synchroInProgress: Bool = false
    var completions: [SynchroCompletion] = []
    
    func synchronizeWithCompletion(completion: SynchroCompletion?, forced: Bool) {
        
        if let completion = completion {
            completions.append(completion)
            print("Synchro request with completion")
        } else {
            print("Synchro request without completion")
        }
    }
    
    func notifyCompletionsWithResult(result: SynchroResult, error: Error?) {
        
        let localCompletions = self.completions
        
        for completion in localCompletions {
            completion(result, error)
        }
        
        var resultString = ""
        
        switch result {
        case .SynchroResultSkipped:
            resultString = "SKIPPED"
        case .SynchroResultOK:
            resultString = "OK"
        case .SynchroResultError:
            resultString = "ERROR \(error?.localizedDescription ?? "")"
        }
        
        print("Synchro finished with result \(resultString) and informed \(self.completions.count) completions")
        
        self.completions = []
    }
}
