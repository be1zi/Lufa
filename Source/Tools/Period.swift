//
//  Period.swift
//  Lufa
//
//  Created by Konrad Belzowski on 18/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

class Period {
    
    static func timeInterval(stringDate: String?) -> String? {
        
        var hours: String = ""
        var minutes: String = ""
        var seconds: String = ""
        
        let digits = CharacterSet.decimalDigits
        
        guard var text = stringDate else {
            return nil
        }
        
        if text.count > 2 {
            text.removeFirst()
            text.removeFirst()
        }
        
        var tmp: String = ""
        
        for char in text.unicodeScalars {
            
            if digits.contains(char) {
                tmp.append(char.description)
            } else {
                if tmp.count == 1 {
                    var newString = "0"
                    newString = "\(newString)" + tmp
                    tmp = newString
                } else if tmp.count == 0 {
                    tmp = "00"
                }
                
                if char.description == "M" {
                    minutes = tmp
                } else if char.description == "H" {
                    hours = tmp
                } else if char.description == "S" {
                    seconds = tmp
                }
                
                tmp = ""
            }
        }
                
        return "\(hours):\(minutes):\(seconds)"
    }
}
