//
//  RemoteRepositoryContext+Duty.swift
//  Lufa
//
//  Created by Konrad Belzowski on 03/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

var TIME_INTERVAL: Double = 60 * 60 * 24 * 7

extension RemoteRepositoryContext {
 
    func getEventsWithPeriodOfTime(from: Date, to: Date?, withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        
        var endDate: Date
        
        if let toDate = to {
            endDate = toDate
        } else {
            endDate = Date.init(timeIntervalSinceNow: TIME_INTERVAL)
        }
        
        let params: [String: Any] = ["fromDate" : from,
                                     "toDate" : endDate]
        get(endPoint: "v1/flight_operations/crew_services/COMMON_DUTY_EVENTS", parameters: params, contentType: .JSON , withSuccess: { response in
            
            DispatchQueue.global().async {
                
                if let response = response {
                    LocalRepositoryContext.sharedInstance.parseAndSave(data: response, name: "Duty")
                }
                
                DispatchQueue.main.async {
                 
                    if let success = success {
                        success(nil)
                    }
                    
                }
            }
            
        }) { error in
            
            DispatchQueue.global().async {
                
                if let result = JsonReader.loadFromFile(withName: "duty_1") {
                    LocalRepositoryContext.sharedInstance.parseAndSave(data: result, name: "Duty")
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
