//
//  RemoteRepositoryContextCrew.swift
//  Lufa
//
//  Created by Konrad Belzowski on 27/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

extension RemoteRepositoryContext {
        
    func getAllCrew(withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
                
        get(endPoint: "v1/flight_operations/crew_services/COMMON_CREWLIST", parameters: nil, contentType: .JSON, withSuccess: { responce in
            
            DispatchQueue.global().async {
                
                if let result = responce {
                    LocalRepositoryContext.sharedInstance.parseAndSave(data: result, name: "Crew")
                }
                
                DispatchQueue.main.async {
                    
                    if let success = success {
                        success(nil)
                    }
                }
            }
            
        }) { error in
            
            DispatchQueue.global().async {
                
                if let result = JsonReader.loadFromFile(withName: "crew_1") {
                    LocalRepositoryContext.sharedInstance.parseAndSave(data: result, name: "Crew")
                }
                
                DispatchQueue.main.async {
                    
                    if let failure = failure {
                        failure(error)
                    }
                }
            }
        }
    }
}
