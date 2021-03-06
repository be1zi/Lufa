//
//  RemoteRepositoryContext+Country.swift
//  Lufa
//
//  Created by Konrad Belzowski on 10/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

extension RemoteRepositoryContext {
    
    func getAllCountries(withOffset offset: Int, result: [[String: Any]], withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        
        let language = LanguageManager.sharedInstance.currentLanguage
        
        getOpen(endPoint: "v1/references/countries/?lang=\(language)&limit=100&offset=\(offset)", parameters: nil, contentType: .JSON, withSuccess: { response in
            
            var localResult = result
            let res = self.prepareData(response: response)
            let localOffset = offset + res.count
                
            localResult.append(contentsOf: res)
                
            if res.count < 100 {
                LocalRepositoryContext.sharedInstance.parseAndSave(data: localResult, name: "Country")
                    
                DispatchQueue.main.async {
                        
                    if let success = success {
                        success(nil)
                    }
                }
            } else {
                sleep(1)

                self.getAllCountries(withOffset: localOffset,
                                     result: localResult,
                                     withSuccess: success,
                                     andFailure: failure)
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

// MARK: Helpers
extension RemoteRepositoryContext {
    
    fileprivate func prepareData(response: [String: Any]?) -> [[String: Any]] {
        
        var result: [[String: Any]] = []
        
        if let response = response,
            let data = response["CountryResource"] as? [String: Any],
            let countries = data["Countries"] as? [String: Any],
            let country = countries["Country"] as? [[String: Any]] {
        
            for element in country {
                if let code = element["CountryCode"] as? String,
                    let names = element["Names"] as? [String: Any],
                    let name = names["Name"] as? [String: Any],
                    let languageName = name["$"] as? String {
                    
                    result.append(["code": code, "name": languageName])
                }
            }
        }
        
        return result
    }
}
