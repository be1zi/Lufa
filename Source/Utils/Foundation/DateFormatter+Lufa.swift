//
//  DateFormatter+Lufa.swift
//  Lufa
//
//  Created by Konrad Belzowski on 03/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

var DEFAULT_DATE_FORMAT: String {get {return "dd-MM-yyyy"}}

extension DateFormatter {
    
    static func dateToString(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DEFAULT_DATE_FORMAT
        
        return dateFormatter.string(from: date)
    }
}
