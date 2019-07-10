//
//  SynchronizationFactory.swift
//  Lufa
//
//  Created by Konrad Belzowski on 09/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

class SynchronizationFactory {

    static func getGeneralCellsTypesArray() -> [SynchroType] {
        var array: [SynchroType] = []
        
        array.append(.SynchroTypeAirline)
        array.append(.SynchroTypeCities)
        array.append(.SynchroTypeCountries)

        return array
    }
    
    static func getSpecificCellsTypesArray() -> [SynchroType] {
        var array: [SynchroType] = []
        
        array.append(.SynchroTypeCrew)
        array.append(.SynchroTypeFlights)
        
        return array
    }
    
    static func getTitleForCell(withType type: SynchroType) -> String {

        switch type {
        case .SynchroTypeAirline:
            return "synchronization.cell.airline.title".localized()
        case .SynchroTypeCities:
            return "synchronization.cell.cities.title".localized()
        case .SynchroTypeCountries:
            return "synchronization.cell.countries.title".localized()
        case .SynchroTypeCrew:
            return "synchronization.cell.crew.title".localized()
        case .SynchroTypeFlights:
            return "synchronization.cell.flights.title".localized()
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
