//
//  String+Lufa.swift
//  Lufa
//
//  Created by Konrad Belzowski on 04/04/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

extension String {
    
    func localized() -> String {
        
        let currentLanguage = LanguageManager.sharedInstance.currentLanguage
        
        guard let path: String = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") else {
            return self
        }
        
        guard let bundle: Bundle = Bundle.init(path: path) else {
            return self
        }
        
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
    
    static func countdownText(days: Int?, hours: Int?, minutes: Int?, seconds: Int?) -> String? {
        
        var components = [Int]()
        var result = ""
        
        if let d = days, d > 0 { components.append(d) }
        if let h = hours { components.append(h)}
        if let m = minutes { components.append(m) }
        if let s = seconds { components.append(s) }
        
        components.forEach { element in
            
            if element < 10 {
                result.append("0\(element)")
            } else {
                result.append("\(element)")
            }
            
            if components.firstIndex(of: element) != components.count - 1 { result += " : " }
        }
        
        return result
    }
}
