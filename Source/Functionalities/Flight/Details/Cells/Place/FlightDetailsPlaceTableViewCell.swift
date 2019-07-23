//
//  FlightDetailsPlaceTableViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 18/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class FlightDetailsPlaceTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var departureGateTitleLabel: UILabel!
    @IBOutlet weak var departurePositionTitleLabel: UILabel!
    @IBOutlet weak var arrivalGateTitleLabel: UILabel!
    @IBOutlet weak var arrivalPositionTitleLabel: UILabel!
    @IBOutlet weak var departureTitleLabel: UILabel!
    @IBOutlet weak var arrivalTitleLabel: UILabel!
    
    @IBOutlet weak var departureGateValueLabel: UILabel!
    @IBOutlet weak var departurePositionValueLabel: UILabel!
    @IBOutlet weak var arrivalGateValueLabel: UILabel!
    @IBOutlet weak var arrivalPositionValueLabel: UILabel!
    
    var flight: Flight?
    
    func loadWithData(flight: Flight) {
        self.flight = flight
        
        setData()
    }
    
    func setData() {
        
        departureTitleLabel.text = "flight.details.cell.places.departure".localized()
        departureGateTitleLabel.text = "flight.details.cell.places.gate".localized()
        departurePositionTitleLabel.text = "flight.details.cell.places.position".localized()
        arrivalTitleLabel.text = "flight.details.cell.places.arrival".localized()
        arrivalGateTitleLabel.text = "flight.details.cell.places.gate".localized()
        arrivalPositionTitleLabel.text = "flight.details.cell.places.position".localized()
        
        guard let flight = flight else {
            departurePositionValueLabel.text = nil
            departureGateValueLabel.text = nil
            arrivalGateValueLabel.text = nil
            arrivalPositionValueLabel.text = nil
            
            return
        }
        
        departureGateValueLabel.text = flight.departureGate
        departurePositionValueLabel.text = flight.departurePosition
        arrivalGateValueLabel.text = flight.arrivalGate
        arrivalPositionValueLabel.text = flight.arrivalPosition
    }
}
