//
//  SynchronizationFactory.swift
//  Lufa
//
//  Created by Konrad Belzowski on 09/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

protocol SynchronizationDelegate {
    func allCheckboxChangeState(newState: Bool, type: SynchronizationSectionType)
    func checkboxChangeState(newState: Bool, section: SynchronizationSectionType, type: SynchroType)
}

class SynchronizationFactory {

    static func getGeneralCellsTypesArray() -> [SynchroType] {
        var array: [SynchroType] = []
        
        array.append(.Airline)
        array.append(.Cities)
        array.append(.Countries)

        return array
    }
    
    static func getSpecificCellsTypesArray() -> [SynchroType] {
        var array: [SynchroType] = []
        
        array.append(.Crew)
        array.append(.Flights)
        
        return array
    }
    
    static func getTitleForCell(withType type: SynchroType) -> String {

        switch type {
        case .Airline:
            return "synchronization.cell.airline.title".localized()
        case .Cities:
            return "synchronization.cell.cities.title".localized()
        case .Countries:
            return "synchronization.cell.countries.title".localized()
        case .Crew:
            return "synchronization.cell.crew.title".localized()
        case .Flights:
            return "synchronization.cell.flights.title".localized()
        default:
            return ""
        }
    }
    
    static func getTitleForHeader(withType type: SynchronizationSectionType) -> String {
        
        switch type {
        case .General:
            return "synchronization.header.general.title".localized()
        case .Specific:
            return "synchronization.header.specific.title".localized()
        default:
            return ""
        }
    }
}
