//
//  FlightFilterItem.swift
//  Lufa
//
//  Created by Konrad Belzowski on 25/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

enum FilterType {
    case date
    case place
    case travelTime
    case type
    case unknown
}

enum FilterKeyType: Hashable {
    case min
    case max
    case value
}

class FlightFilterItem {
    
    var type: FilterType
    var values: [FilterKeyType: Any]
    
    init(type: FilterType = .unknown, values: [FilterKeyType: Any] = [:]) {
        self.type = type
        self.values = values
    }
    
    init(type: FilterType, value: Any, key: FilterKeyType) {
        self.type = type
        self.values = [FilterKeyType: Any]()
        self.setValue(value: value, key: key)
    }
    
    func setValue(value: Any, key: FilterKeyType) {
        values = [key: value]
    }
    
    func addValue(value: Any, key: FilterKeyType) {
        values[key] = value
    }
    
    func isEmpty() -> Bool {
        return values.count == 0
    }
}
