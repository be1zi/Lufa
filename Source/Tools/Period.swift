//
//  Period.swift
//  Lufa
//
//  Created by Konrad Belzowski on 18/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

class Period {
    
    static func timeInterval(stringDate: String?) -> (hours: Int?, minutes: Int?, seconds: Int? )? {
        
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
                
        return (Int(hours), Int(minutes), Int(seconds))
    }
    
    static func timeIntervalMiliseconds(stringDate: String?) -> TimeInterval? {
        
        guard let (hours, minutes, seconds) = timeInterval(stringDate: stringDate) else {
            return nil
        }
        
        var time = 0
        time += (hours ?? 0) * 60 * 60
        time += (minutes ?? 0) * 60
        time += seconds ?? 0
        time *= 1000
        
        return TimeInterval(exactly: time)
    }
    
    static func periodFromInterval(interval: Int) -> (hours: Int?, minutes: Int?, seconds: Int?) {
        
        var time = interval
        var hours = 0, minutes = 0, seconds = 0
        var returnHours, returnMinutes, returnSeconds: Int?
        
        time /= 1000
        
        hours = time / (60 * 60)
        time -= hours * 60 * 60
        
        minutes = time / 60
        time -= minutes * 60
        
        seconds = time
        
        if hours > 0 { returnHours = hours }
        if minutes > 0 { returnMinutes = minutes }
        if seconds > 0 { returnSeconds = seconds }
        
        return (returnHours, returnMinutes, returnSeconds)
    }
    
    static func periodToDisplay(interval: Int) -> String? {
        
        let (hours, minutes, seconds) = periodFromInterval(interval: interval)
        
        if hours == nil, minutes == nil, seconds == nil { return nil }
        
        var result = ""
        var components = [String]()
        
        if let h = hours {components.append("\(h)h") }
        if let m = minutes { components.append("\(m)m") }
        if let s = seconds { components.append("\(s)s") }
        
        components.forEach { element in
            result += element
            if components.firstIndex(of: element) != components.count - 1 { result += " : "}
        }
        
        return result
    }
    
    static func remainingTimeToDate(date: Date?) -> (days: Int?, minutes: Int?, hours: Int?, seconds: Int?) {
        
        guard let date = date else {
            return (nil, nil, nil, nil)
        }
        
        let currentDate = Date.init()
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.hour, .minute, .second, .day], from: currentDate)
        let comparisionComponents = calendar.dateComponents([.hour, .minute, .second, .day], from: date)
        
        let comparisionDayDifference = calendar.dateComponents([.day, .hour, .minute, .second], from: comparisionComponents, to: currentComponents)
        
        return (comparisionDayDifference.day,
                comparisionDayDifference.hour,
                comparisionDayDifference.minute,
                comparisionDayDifference.second)
    }
}
