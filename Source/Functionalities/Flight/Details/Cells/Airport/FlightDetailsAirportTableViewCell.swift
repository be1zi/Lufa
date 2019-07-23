//
//  FlightDetailsAirportTableViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 17/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class FlightDetailsAirportTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var fromValueLabel: UILabel!
    @IBOutlet weak var toValueLabel: UILabel!
    
    var flight: Flight?
    var from: City?
    var to: City?
    
    func loadWithData(flight: Flight) {
        self.flight = flight
        
        from = LocalRepositoryContext.sharedInstance.getCityName(shortCut: flight.departureAirport)
        to = LocalRepositoryContext.sharedInstance.getCityName(shortCut: flight.arrivalAirport)
        
        setData()
    }
    
    func setData() {
        
        guard flight != nil else {
            fromLabel.text = nil
            toLabel.text = nil
            typeView.backgroundColor = UIColor.clear
            typeLabel.text = nil
            fromValueLabel.text = nil
            toValueLabel.text = nil
            
            return
        }
        
        fromLabel.text = "flight.details.cell.airport.from".localized()
        toLabel.text = "flight.details.cell.airport.to".localized()
        
        var fromCountryCode: String?
        var toCountryCode: String?
        
        if let from = from, let name = from.name {
            fromCountryCode = from.countryCode
            fromValueLabel.text = name
        } else {
            fromValueLabel.text = nil
        }
        
        if let to = to, let name = to.name {
            toCountryCode = to.countryCode
            toValueLabel.text = name
        } else {
            toValueLabel.text = nil
        }
        
        if let fromCountry = fromCountryCode, let toCountry = toCountryCode {
            if fromCountry == toCountry {
                typeLabel.text = "flight.details.cell.airport.local".localized()
                typeView.backgroundColor = UIColor.lufaCyanColor
            } else {
                typeLabel.text = "flight.details.cell.airport.international".localized()
                typeView.backgroundColor = UIColor.lufaGreenColor
            }
        } else {
            typeView.backgroundColor = UIColor.clear
            typeLabel.text = nil
        }
    }
}
