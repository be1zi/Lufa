//
//  RemoteRepositoryContext+CheckIn.swift
//  Lufa
//
//  Created by Konrad Belzowski on 05/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

extension RemoteRepositoryContext {
    
    func getCheckIn(params: [String: Any]?, withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        
        get(endPoint: "v1/flight_operations/crew_services/COMMON_CHECK_IN_TIMES", parameters: params, contentType: .JSON, withSuccess: { response in
            
            DispatchQueue.global().async {
                
                if let response = response {
                    LocalRepositoryContext.sharedInstance.parseAndSave(data: response, name: "CheckIn")
                }
                
                DispatchQueue.main.async {
                    
                    if let success = success {
                        success(nil)
                    }
                }
                
            }
        }) { error in
            
            DispatchQueue.global().async {
            
                if let result = JsonReader.loadFromFile(withName: "check-in_1") {
                    LocalRepositoryContext.sharedInstance.parseAndSave(data: result, name: "CheckIn")
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
