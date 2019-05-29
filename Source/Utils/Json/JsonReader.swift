//
//  JsonReader.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/05/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

class JsonReader {
    
    static func loadFromFile(withName name: String) -> Dictionary<String, AnyObject>? {
        
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    return jsonResult
                }
            } catch let error {
                print("Json reader error: \(error.localizedDescription)")
            }
        }
        
        return nil
    }
}
