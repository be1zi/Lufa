//
//  RemoteRepositoryContext+Airlines.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

extension RemoteRepositoryContext {
    
    func getAllAirlines(withOffset offset: Int, result: [[String: Any]], withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        
        let language = LanguageManager.sharedInstance.currentLanguage
        
        getOpen(endPoint: "v1/mds-references/airlines/?lang=\(language)&limit=100&offset=\(offset)", parameters: nil, contentType: .JSON, withSuccess: { response in
            
            DispatchQueue.global().async {
                
                var localResult = result
                let res = self.prepareData(response: response)
                let localOffset = offset + res.count
                
                localResult.append(contentsOf: res)
                
                if res.count < 100 {
                    LocalRepositoryContext.sharedInstance.parseAndSave(data: result, name: "Airline")
                    
                    DispatchQueue.main.async {
                        
                        if let success = success {
                            success(nil)
                        }
                    }
                } else {
                    sleep(1)
                    
                    self.getAllAirlines(withOffset: localOffset, result: localResult, withSuccess: success, andFailure: failure)
                }
            }
        }) { error in
            
            DispatchQueue.main.async {
                
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
}

//MARK: - Helper
extension RemoteRepositoryContext {
    
    fileprivate func prepareData(response: [String: Any]?) -> [[String: Any]] {
        
        var result: [[String: Any]] = []
        
        if let response = response,
            let resource = response["AirlineResource"] as? [String: Any],
            let airlines = resource["Airlines"] as? [String: Any],
            let airline = airlines["Airline"] as? [[String: Any]] {
            
            for element in airline {
                
                if let code = element["AirlineID"] as? String,
                    let codeICAO = element["AirlineID_ICAO"] as? String,
                    let names = element["Names"] as? [String: Any],
                    let name = names["Name"] as? [String: Any],
                    let airlineName = name["$"] as? String {
                    
                    result.append(["code" : code, "codeICAO" : codeICAO, "name" : airlineName])
                }
            }
        }
        
        return result
    }
}
