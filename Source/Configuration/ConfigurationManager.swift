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
            
            let api: Dictionary<String, Any> = dictWrapped["LufaAPI"] as! Dictionary<String, Any>
            
            guard let result = api["serverAddress"] as? String else {
                return nil
            }
            
            return result
        }
    }
    
    //MARK: Helper
    func loadConfiguration() -> Dictionary<String, Any>? {
        
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
}
