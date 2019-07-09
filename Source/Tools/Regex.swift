//
//  Regex.swift
//  Lufa
//
//  Created by Konrad Belzowski on 09/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

class Regex {
    
    static private let EMAIL_REGEX = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    static func isValidEmail(email: String?) -> Bool {
        
        guard let email = email else {
            return false
        }
        
        let regex = try? NSRegularExpression(pattern: EMAIL_REGEX, options: .caseInsensitive)
        
        if let regex = regex {
            return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
        }
        
        return false
    }
}
