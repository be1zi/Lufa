//
//  RemoteRepositoryContext+Authenticate.swift
//  Lufa
//
//  Created by Konrad Belzowski on 29/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

extension RemoteRepositoryContext {
    
    //get access token
    func authorize(withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        
        guard let clientId = ConfigurationManager.sharedInstance.serverKey else {
            print("ERROR authorize: clientKey not configured")
            return
        }
        
//        let params = ["response_type" : "code",
//                      "client_id" : clientId]
//
//        get(endPoint: "/lhcrew/oauth/authorize", parameters: params, contentType: .XFORM, withSuccess: { result in
//
//            if let success = success {
//                success(result)
//            }
////            guard let result = result else {
////                if let failure = failure {
////                    failure(nil)
////                }
////
////                return
////            }
//
//        }) { error in
//            if let failure = failure {
//                failure(error)
//            }
//        }
        
        guard let clientSecret = ConfigurationManager.sharedInstance.serverSecret else {
            print("ERROR authorize: clientSecret not configured")
            return
        }

        let params = ["client_id" : clientId,
                      "client_secret" : clientSecret,
                      "grant_type" : "client_credentials"] as [String: String]

        post(endPoint: "/lhcrew/oauth/token", parameters: params, contentType: .XFORM, withSuccess: { result in

            DispatchQueue.global().async {
            
                guard let result = result else {
                    
                    DispatchQueue.main.async {
                        if let failure = failure {
                            failure(nil)
                        }
                    }
                    
                    return
                }
                
                guard let tokenType = result["token_type"] as? String else {
                    
                    DispatchQueue.main.async {
                        if let failure = failure {
                            failure(nil)
                        }
                    }
                    
                    return
                }
                
                guard let token = result["access_token"] as? String else {
                    
                    DispatchQueue.main.async {
                        if let failure = failure {
                            failure(nil)
                        }
                    }
                    
                    return
                }
                
                AppDelegate.sharedInstance.setAuthorizationToken(token: token, type: tokenType)
                
                DispatchQueue.main.async {
                    if let success = success {
                        success(nil)
                    }
                }
            }
            
        }) { error in
//            if let failure = failure {
//                failure(error)
//            }
            DispatchQueue.main.async {
                if let success = success {
                    success(nil)
                }
            }
        }
    }
    
    //logout from the backend - invalidate token
    func logout(withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        
        guard let clientId = ConfigurationManager.sharedInstance.serverKey else {
            print("ERROR authorize: clientKey not configured")
            
            if let failure = failure {
                failure(nil)
            }
            
            return
        }
        
        guard let clientSecret = ConfigurationManager.sharedInstance.serverSecret else {
            print("ERROR authorize: clientSecret not configured")
            
            if let failure = failure {
                failure(nil)
            }
            
            return
        }
        
        guard let accessToken = AppDelegate.sharedInstance.getAuthorizationToken() else {
            print("ERROR logout: empty access token")
            
//            if let failure = failure {
//                failure(nil)
//            }
            if let success = success {
                success(nil)
            }
            
            return
        }
        
        let params = ["client_id" : clientId,
                      "client_secret" : clientSecret,
                      "access_token" : accessToken]
        
        post(endPoint: "/lhcrew/logout_backend", parameters: params, contentType: .XFORM, withSuccess: { result in
            
            DispatchQueue.global().async {
                guard let result = result else {
                    
                    DispatchQueue.main.async {
                        if let failure = failure {
                            failure(nil)
                        }
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    if let success = success {
                        success(result)
                    }
                }
            }
            
        }) { error in
//            if let failure = failure {
//                failure(error)
//            }
            
            DispatchQueue.main.async {
                if let success = success {
                    success(nil)
                }
            }
        }
    }
}
