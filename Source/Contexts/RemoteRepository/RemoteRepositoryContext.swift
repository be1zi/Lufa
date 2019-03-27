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
typealias RemoteRepositoryFailure = () -> (Error?)

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
    
    
    func get(endPoint end: String?) {
    
        guard let address = prepareAddress(endPoint: end) else {
            return
        }
        
        guard let url = URL.init(string: address) else {
            return
        }
        
        //TODO: send request using alamofire - AF.request
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
