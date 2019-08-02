//
//  LanguageManager.swift
//  Lufa
//
//  Created by Konrad Belzowski on 04/04/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

let LANGUAGE_PL = "pl"
let LANGUAGE_EN = "en"

class LanguageManager {
    
    static var sharedInstance = LanguageManager()
    
    var languageChanged = false
    
    var currentLanguage: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "currentLanguage")
            UserDefaults.standard.synchronize()
            languageChanged = true
        }
        get {
            return UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? LANGUAGE_EN
        }
    }
    
    func selectedBefore() -> Bool {
        return UserDefaults.standard.object(forKey: "currentLanguage") as? String != nil
    }
}
