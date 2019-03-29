//
//  RemoteRepositoryContext+Authenticate.swift
//  Lufa
//
//  Created by Konrad Belzowski on 29/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

extension RemoteRepositoryContext {
    
    func authorize(withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        
        guard let clientId = ConfigurationManager.sharedInstance.serverKey else {
            print("ERROR authorize: clientKey not configured")
            return
        }
        
        guard let clientSecret = ConfigurationManager.sharedInstance.serverSecret else {
            print("ERROR authorize: clientSecret not configured")
            return
        }
        
        let params = ["client_id" : clientId,
                      "client_secret" : clientSecret,
                      "grant_type" : "client_credentials"] as [String: String]
        
        post(endPoint: "/v1/oauth/token", parameters: params, contentType: .XFORM, withSuccess: { result in
            if let success = success {
                success(result)
            }
        }) { error in
            if let failure = failure {
                failure(error)
            }
        }
    }
}
