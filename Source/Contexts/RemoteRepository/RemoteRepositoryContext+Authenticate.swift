//
//  RemoteRepositoryContext+Authenticate.swift
//  Lufa
//
//  Created by Konrad Belzowski on 29/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

extension RemoteRepositoryContext {
    
    func authorize() {
        
        guard let clientID = ConfigurationManager.sharedInstance.serverKey else {
            return
        }
        
        let address = self.prepareAddress(endPoint: "lhcrew/oauth/authorize?response_type=code&scope=https://mock.cms.fra.dlh.de/publicCrewApiDev&client_id=\(clientID)&redirect_uri=Lufa://authorizeCallback/&code_challenge=123456789123456789123456789123456789123456789&code_challenge_method=S256&state=abc123xyz", apiType: .FlightOpsWithToken)
        
        if let address = address {
            AppDelegate.sharedInstance.openURL(address: address)
        }
    }
    
    func authenticate(withCode code: String, success: RemoteRepositorySuccess?, failure: RemoteRepositoryFailure?) {
        
        guard let clientID = ConfigurationManager.sharedInstance.serverKey else {
            print("ERROR authenticate: clientKey not configured")
            return
        }
        
        let params = ["grant_type": "authorization_code",
                      "client_id": clientID,
                      "redirect_uri": "Lufa://authorizeCallback/",
                      "code": code,
                      "code_verifier": "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"]
        
        postAuthenticate(endPoint: "lhcrew/oauth/token", parameters: params, contentType: .XFORM, withSuccess: { _ in
            
            DispatchQueue.main.async {
                if let success = success {
                    success(nil)
                }
            }
        }) { _ in
            DispatchQueue.main.async {
//                if let failure = failure {
//                    failure(error)
//                }
                if let success = success {
                    success(nil)
                }
            }
        }
    }
    
    func authorizeOpen(withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        
        guard let clientId = ConfigurationManager.sharedInstance.openServerKey else {
            print("ERROR authorizeOpen: clientKey not configured")
            return
        }
        
        guard let clientSecret = ConfigurationManager.sharedInstance.openServerSecret else {
            print("ERROR authorizeOpen: clientSecret not configured")
            return
        }
        
        let params = ["client_id": clientId,
                      "client_secret": clientSecret,
                      "grant_type": "client_credentials"] as [String: String]
        
        postOpenAuthorize(endPoint: "/v1/oauth/token", parameters: params, contentType: .XFORM, withSuccess: { result in
            
            DispatchQueue.global().async {
                
                guard let result = result else {
                    
                    DispatchQueue.main.async {
                        if let failure = failure {
                            failure(nil)
                        }
                    }
                    
                    return
                }
                
                if LocalRepositoryContext.sharedInstance.getEmployee() == nil {
                    let data = self.prepareDataForUser()
                    LocalRepositoryContext.sharedInstance.parseAndSave(data: data, name: "Employee")
                }
                
                guard let token = result["access_token"] as? String else {
                    
                    DispatchQueue.main.async {
                        if let failure = failure {
                            failure(nil)
                        }
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    AppDelegate.sharedInstance.setAuthorizationOpenToken(token: token)

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
        
        let params = ["client_id": clientId,
                      "client_secret": clientSecret,
                      "access_token": accessToken]
        
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
            
        }) { _ in
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
    
    fileprivate func prepareDataForUser() -> [String: Any] {
        
        let data: [String: Any] = ["pkNumber": "064012K",
                                   "firstName": "Jon",
                                   "lastName": "Snow",
                                   "crewPosition": "PU",
                                   "dutyCode": "OD",
                                   "email": "john.snow@winterfell.com",
                                   "phone": "666999012",
                                   "birthDate": "1995-11-05Z"]
        
        return data
    }
}
