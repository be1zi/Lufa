//
//  RemoteRepositoryContext+Country.swift
//  Lufa
//
//  Created by Konrad Belzowski on 10/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

extension RemoteRepositoryContext {
    
    func getAllCountries(withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        
        let language = LanguageManager.sharedInstance.currentLanguage
        
        getOpen(endPoint: "v1/references/countries/?lang=\(language)", parameters: nil, contentType: .JSON, withSuccess: { response in
            
            DispatchQueue.global().async {
                
                if let response = response {
                    LocalRepositoryContext.sharedInstance.parseAndSave(data: response, name: "Country")
                }
                
                DispatchQueue.main.async {
                    
                    if let success = success {
                        success(nil)
                    }
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
