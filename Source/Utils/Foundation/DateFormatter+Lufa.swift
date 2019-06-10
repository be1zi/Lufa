//
//  DateFormatter+Lufa.swift
//  Lufa
//
//  Created by Konrad Belzowski on 03/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

var DEFAULT_DISPLAY_DATE_FORMAT: String {get {return "dd-MM-yyyy"}}
var DATE_FORMAT: String {get {return "yyyy-MM-ddZ"}}
var DATE_TIME_FORMAT: String {get {return "yyyy-MM-dd'T'HH:mm:ssZ"}}

extension DateFormatter {
    
    static func dateToString(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DEFAULT_DISPLAY_DATE_FORMAT
        
        return dateFormatter.string(from: date)
    }
    
    static func stringToDate(date: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT
        
        return dateFormatter.date(from: date)
    }
    
    static func stringToDateTime(date: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_TIME_FORMAT
        
        return dateFormatter.date(from: date)
    }
}
