//
//  RemoteRepositoryContext.swift
//  Lufa
//
//  Created by Konrad Belzowski on 27/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import Alamofire

typealias RemoteRepositorySuccess = () -> Void
typealias RemoteRepositoryFailure = (Error?) -> Void

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
    
    func get(endPoint end: String?, parameters: Dictionary<String, Any>?) {
    
        guard let address = prepareAddress(endPoint: end) else {
            return
        }
        
        guard let url = URL.init(string: address) else {
            return
        }
        
        //TODO: send request using alamofire - AF.request
        
        AF.request(url,
                   method: .get,
                   parameters: ["a" : "b"])
            .validate()
            .responseJSON { response in
            
                guard response.result.isSuccess else {
                    print("ERROR request GET from: \(address), message: \(response.error?.localizedDescription ?? "empty message")")
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    print("Wrong response value from: \(address), message: \(response.error?.localizedDescription ?? "empty message")")
                    return
                }
                
                print(value)
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
}
