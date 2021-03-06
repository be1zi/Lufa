//
//  RemoteRepositoryContext.swift
//  Lufa
//
//  Created by Konrad Belzowski on 27/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import Alamofire

typealias RemoteRepositorySuccess = ([String: Any]?) -> Void
typealias RemoteRepositoryFailure = (Error?) -> Void

enum ContentType {
    case JSON, XFORM
}

enum ApiType {
    case OpenWithToken, OpenWithoutToken, FlightOpsWithToken, FlightOpsWithoutToken
}

class RemoteRepositoryContext {
    
    let serverAddress: String?
    let openServerAddress: String?
    
    // MARK: Singleton
    static let sharedInstance = RemoteRepositoryContext()
    
    // MARK: Constructor
    init() {
        
        guard let address = ConfigurationManager.sharedInstance.serverAddress else {
            self.serverAddress = nil
            self.openServerAddress = nil
            return
        }
        
        guard let openAddress = ConfigurationManager.sharedInstance.openServerAddress else {
            self.serverAddress = nil
            self.openServerAddress = nil
            return
        }
        
        self.serverAddress = address
        self.openServerAddress = openAddress
    }
    
    // MARK: Http methods
    
    func get(endPoint end: String?, parameters: [String: Any]?, contentType: ContentType?, withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        get(endPoint: end, parameters: parameters, apiType: .FlightOpsWithToken, contentType: contentType, withSuccess: success, andFailure: failure)
    }
    
    func getOpen(endPoint end: String?, parameters: [String: Any]?, contentType: ContentType?, withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        get(endPoint: end, parameters: parameters, apiType: .OpenWithToken, contentType: contentType, withSuccess: success, andFailure: failure)
    }
    
    private func get(endPoint end: String?, parameters: [String: Any]?, apiType: ApiType, contentType: ContentType?, withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        
        guard let address = prepareAddress(endPoint: end, apiType: apiType) else {
            return
        }
        
        guard let url = URL.init(string: address) else {
            return
        }
        
        let headers = getHeader(contentType: contentType, apiType: apiType)
        let encoding = getEncoding(contentType: contentType)
        let params = prepareData(data: parameters)
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: encoding,
                   headers: headers)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("ERROR request GET from: \(address), message: \(response.error?.localizedDescription ?? "empty message")")
                    
                    if let failure = failure {
                        failure(response.error)
                    }
                    
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    print("Wrong response value type from: \(address), message: \(response.error?.localizedDescription ?? "empty message")")
                    return
                }
                
                if let success = success {
                    success(value)
                }
        }
    }
    
    func postAuthenticate(endPoint end: String?, parameters: [String: Any]?, contentType: ContentType?, withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        post(endPoint: end, parameters: parameters, apiType: .FlightOpsWithoutToken, contentType: contentType, withSuccess: success, andFailure: failure)
    }
    
    func post(endPoint end: String?, parameters: [String: Any]?, contentType: ContentType?, withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        post(endPoint: end, parameters: parameters, apiType: .FlightOpsWithToken, contentType: contentType, withSuccess: success, andFailure: failure)
    }
    
    func postOpen(endPoint end: String?, parameters: [String: Any]?, contentType: ContentType?, withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        post(endPoint: end, parameters: parameters, apiType: .OpenWithToken, contentType: contentType, withSuccess: success, andFailure: failure)
    }
    
    func postOpenAuthorize(endPoint end: String?, parameters: [String: Any]?, contentType: ContentType?, withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        post(endPoint: end, parameters: parameters, apiType: .OpenWithoutToken, contentType: contentType, withSuccess: success, andFailure: failure)
    }
    
    private func post(endPoint end: String?, parameters: [String: Any]?, apiType: ApiType, contentType: ContentType?, withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        
        guard let address = prepareAddress(endPoint: end, apiType: apiType) else {
            return
        }
        
        guard let url = URL.init(string: address) else {
            return
        }
        
        let headers = getHeader(contentType: contentType, apiType: apiType)
        let encoding = getEncoding(contentType: contentType)
        let params = prepareData(data: parameters)

        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: encoding,
                   headers: headers)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                
                    print("ERROR request POST from: \(address), message: \(response.error?.localizedDescription ?? "empty message")")
                    
                    if let data = response.data {
                        print(String(data: data, encoding: String.Encoding.utf8) ?? "")
                    }
                    
//                    if let data = response.request?.httpBody {
//                        print(String(data: data, encoding: String.Encoding.utf8) ?? "")
//                    }
                    
                    if let failure = failure {
                        failure(response.error)
                    }
                    
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    print("Wrong response value type from: \(address), message: \(response.error?.localizedDescription ?? "empty message")")
                    
                    return
                }
                
                if let success = success {
                    success(value)
                }
        }
    }
    
    // MARK: Helper
    func prepareAddress(endPoint: String?, apiType: ApiType) -> String? {
        
        var serverAdd: String
        
        switch apiType {
        case .OpenWithoutToken, .OpenWithToken:
            if let address = openServerAddress {
                serverAdd = address
            } else {
                return nil
            }
        case .FlightOpsWithoutToken, .FlightOpsWithToken:
            if let address = serverAddress {
                serverAdd = address
            } else {
                return nil
            }
        }
        
        guard var endP = endPoint else {
            return nil
        }
        
        if !serverAdd.hasSuffix("/") {
            serverAdd.append("/")
        }
        
        if endP.hasPrefix("/") {
            endP.remove(at: endP.startIndex)
        }
        
        serverAdd.append(endP)
        
        return serverAdd
    }
    
    private func getHeader(contentType: ContentType?, apiType: ApiType?) -> HTTPHeaders? {
        let content = contentType ?? ContentType.JSON
        let api = apiType ?? ApiType.OpenWithToken
        
        var headers: HTTPHeaders
        
        switch api {
        case .OpenWithToken:
            
            guard let token = AppDelegate.getAuthorizationOpenToken() else {
                return nil
            }
            
            switch content {
            case .JSON:
                headers = ["Accept": "application/json",
                           "Authorization": "Bearer \(token)"]
            case .XFORM:
                headers = ["Content-Type": "application/x-www-form-urlencoded",
                           "Authorization": "Bearer \(token)"]
            }
        case .OpenWithoutToken:
            switch content {
            case .JSON:
                headers = ["Content-Type": "application/JSON"]
            case .XFORM:
                headers = ["Content-Type": "application/x-www-form-urlencoded"]
            }
        case .FlightOpsWithToken:
            switch content {
            case .JSON:
                headers = ["Content-Type": "application/JSON"]
            case .XFORM:
                headers = ["Content-Type": "application/x-www-form-urlencoded"]
            }
        case .FlightOpsWithoutToken:
            switch content {
            case .JSON:
                headers = [:]
            case .XFORM:
                
                guard let clientID = ConfigurationManager.sharedInstance.serverKey else {
                    return nil
                }
                
                guard let clientSecret = ConfigurationManager.sharedInstance.serverSecret else {
                    return nil
                }
                
                let credentials = "\(clientID):\(clientSecret)".data(using: .utf8)?.base64EncodedString()
                
                guard let cred = credentials else {
                    return nil
                }
                
                headers = ["Authorization": cred,
                           "Content-Type": "application/x-www-form-urlencoded"]
            }
        }

        return headers
    }
    
    private func getEncoding(contentType: ContentType?) -> ParameterEncoding {
        let content = contentType ?? ContentType.JSON
        var encoder: ParameterEncoding
        
        switch content {
        case .JSON:
            encoder = JSONEncoding.default
        case .XFORM:
            encoder = URLEncoding()
        }
        
        return encoder
    }
    
    private func prepareData(data: [String: Any]?) -> [String: Any]? {
        
        if var data = data {
            
            for object in data where object.value is Date {
                if let date = object.value as? Date {
                    data[object.key] = DateFormatter.dateToString(date: date)
                }
            }
            
            return data
        }
        
        return nil
    }
    
    // MARK: Network
    func isReachable() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
