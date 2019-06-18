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
    
    //MARK: Properties
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    
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
        
        guard let _ = self.flight else {
            fromLabel.text = nil
            toLabel.text = nil
            typeView.backgroundColor = UIColor.clear
            typeLabel.text = nil
            
            return
        }
        
        var fromCountryCode: String?
        var toCountryCode: String?
        
        if let from = from, let name = from.name {
            fromCountryCode = from.countryCode
            fromLabel.text = "flight.details.cell.airport.from".localized() + " \(name)"
        } else {
            fromLabel.text = nil
        }
        
        if let to = to, let name = to.name {
            toCountryCode = to.countryCode
            toLabel.text = "flight.details.cell.airport.to".localized() + " \(name)"
        } else {
            toLabel.text = nil
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
