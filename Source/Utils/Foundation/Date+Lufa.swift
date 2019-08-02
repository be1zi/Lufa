//
//  Date+Lufa.swift
//  Lufa
//
//  Created by Konrad Belzowski on 02/08/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

extension Date {
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else {
            return nil
        }
        
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    var dayAfter: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
    
    func startDay() -> Date? {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)
    }
    
    func endDate() -> Date? {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)
    }
}
