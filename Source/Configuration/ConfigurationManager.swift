//
//  ConfigurationManager.swift
//  Lufa
//
//  Created by Konrad Belzowski on 22/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

class ConfigurationManager {
    
    //MARK: Singleton
    static let sharedInstance = ConfigurationManager()
    
    //MARK: Getters for config variables
    var serverAddress: String? {
        get {
            return getPropertyFromConfigFile(name: "serverAddress", withRoot: "LufaAPI")
        }
    }
    
    var serverKey: String? {
        get {
            return getPropertyFromConfigFile(name: "key", withRoot: "LufaAPI")
        }
    }
    
    var serverSecret: String? {
        get {
            return getPropertyFromConfigFile(name: "secret", withRoot: "LufaAPI")
        }
    }
    
    var openServerAddress: String? {
        get {
            return getPropertyFromConfigFile(name: "serverAddress", withRoot: "LufaOpenAPI")
        }
    }
    
    var openServerKey: String? {
        get {
            return getPropertyFromConfigFile(name: "key", withRoot: "LufaOpenAPI")
        }
    }
    
    var openServerSecret: String? {
        get {
            return getPropertyFromConfigFile(name: "secret", withRoot: "LufaOpenAPI")
        }
    }
    
    var googleApiKey: String? {
        get {
            return getPropertyFromConfigFile(name: "key", withRoot: "GoogleAPI")
        }
    }
    
    //MARK: Helpers
    
    private func loadConfiguration() -> Dictionary<String, Any>? {
        
        let fileURL = Bundle.main.url(forResource: "config", withExtension: "plist")
        
        let fileData: Data
        let dict: Dictionary<String, Any>
        
        guard let url = fileURL else {
            return nil
        }
        
        do {
            fileData = try Data.init(contentsOf: url)
        } catch let error {
            print("Load network configurations error: \(error.localizedDescription)")
            return nil
        }
        
        do {
            dict = try PropertyListSerialization.propertyList(from: fileData, format: nil) as! [String: Any]
        } catch _ {
            return nil
        }
        
        return dict
    }
    
    private func getPropertyFromConfigFile(name: String, withRoot root: String) -> String? {
        let dict = loadConfiguration()
        
        guard let dictWrapped = dict else {
            return nil
        }
        
        let api: Dictionary<String, Any> = dictWrapped[root] as! Dictionary<String, Any>
        
        guard let result = api[name] as? String else {
            return nil
        }
        
        return result
    }
}
