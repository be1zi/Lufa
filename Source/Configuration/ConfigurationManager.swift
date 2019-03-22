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
    
    //MARK: Getter for serverAddress variable
    var serverAddress: String? {
        get {
            let dict = loadConfiguration()
            
            guard let dictWrapped = dict else {
                return nil
            }
            
            let api: Dictionary<String, Any> = dictWrapped["lufaAPI"] as! Dictionary<String, Any>
            
            guard let result = api["serverAddress"] as? String else {
                return nil
            }
            
            return result
        }
    }
    
    //MARK: Helper
    func loadConfiguration() -> Dictionary<String, Any>? {
        
        let filePath = Bundle.main.path(forResource: "config", ofType: "plist")
        let fileData: Data
        let dict: Dictionary<String, Any>
        
        guard let filePathWrapped = filePath else {
            return nil
        }
        
        guard let url = URL.init(string: filePathWrapped) else {
            return nil
        }
        
        do {
            fileData = try Data.init(contentsOf: url)
        } catch _ {
            return nil
        }
        
        do {
            dict = try PropertyListSerialization.propertyList(from: fileData, format: nil) as! [String: Any]
        } catch _ {
            return nil
        }
        
        return dict
    }
}
