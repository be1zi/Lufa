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

class RemoteRepositoryContext {
    
    let serverAddress: String?
    
    //MARK: Singleton
    static let sharedInstance = RemoteRepositoryContext()
    
    //MARK: Constructor
    init() {
        
        guard let address = ConfigurationManager.sharedInstance.serverAddress else {
            self.serverAddress = nil
            return
        }
        
        self.serverAddress = address
    }
    
    //MARK: Http methods
    
    func get(endPoint end: String?, parameters: [String: Any]?, contentType: ContentType?, withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
    
        guard let address = prepareAddress(endPoint: end) else {
            return
        }
        
        guard let url = URL.init(string: address) else {
            return
        }
        
        let headers = getHeader(contentType: contentType)
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
    
    func post(endPoint end: String?, parameters: [String: Any]?, contentType: ContentType?, withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        
        guard let address = prepareAddress(endPoint: end) else {
            return
        }
        
        guard let url = URL.init(string: address) else {
            return
        }
        
        let headers = getHeader(contentType: contentType)
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
    
    //MARK: Helper
    
    private func prepareAddress(endPoint: String?) -> String? {
        
        guard var serverAdd = serverAddress else {
            return nil
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
    
    private func getHeader(contentType: ContentType?) -> HTTPHeaders {
        let content = contentType ?? ContentType.JSON
        var headers: HTTPHeaders
        
        switch content {
            case .JSON:
                headers = ["Content-Type" : "application/JSON"]
            case .XFORM:
                headers = ["Content-Type" : "application/x-www-form-urlencoded"]
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
            
            for object in data {
                if object.value is Date {
                    data[object.key] = DateFormatter.dateToString(date: object.value as! Date)
                }
            }
            
            return data
        }
        
        return nil
    }
}
