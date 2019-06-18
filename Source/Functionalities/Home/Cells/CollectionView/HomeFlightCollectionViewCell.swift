//
//  HomeFlightCollectionViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 13/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class HomeFlightCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    @IBOutlet weak var flightTypeLabel: UILabel!
    @IBOutlet weak var flightNumberLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    
    var flight: Flight?
    
    func loadWithData(flight: Flight) {
        self.flight = flight
    
        setData()
    }
    
    func setData() {
        
        guard let flight = flight else {
            flightTypeLabel.text = nil
            flightNumberLabel.text = nil
            departureLabel.text = nil
            toLabel.text = nil
            fromLabel.text = nil
            
            return
        }
        
        let from = LocalRepositoryContext.sharedInstance.getCityName(shortCut: flight.departureAirport)
        let to = LocalRepositoryContext.sharedInstance.getCityName(shortCut: flight.arrivalAirport)
        
        toLabel.text = "home.flights.cell.to.title".localized() + " \(to?.name ?? "")"
        fromLabel.text = "home.flights.cell.from.title".localized() + " \(from?.name ?? "")"
        flightNumberLabel.text = "home.flights.cell.flightNumber.title".localized() + " \(flight.flightDesignator ?? "")"
        
        if let departureTime = flight.scheduledTimeOfDeparture {
            
            let time = DateFormatter.timeStringFromDate(date: departureTime)
            
            departureLabel.text = "home.flights.cell.departure.title".localized() + " \(time)"
        } else {
            departureLabel.text = nil
        }
    }
}
