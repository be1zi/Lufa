//
//  FlightDetailsScheduleTableViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 17/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class FlightDetailsScheduleTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var flightDateTitleLabel: UILabel!
    @IBOutlet weak var flightTimeTitleLabel: UILabel!
    @IBOutlet weak var departureTitleLabel: UILabel!
    @IBOutlet weak var arrivalTittleLabel: UILabel!
    
    @IBOutlet weak var flightDateValueLabel: UILabel!
    @IBOutlet weak var flightTimeValueLabel: UILabel!
    @IBOutlet weak var departureValueLabel: UILabel!
    @IBOutlet weak var arrivalValueLabel: UILabel!
    
    var flight: Flight?
    
    func loadWithData(flight: Flight) {
        self.flight = flight
        
        setData()
    }
    
    func setData() {
        
        guard let data = flight else {
            return
        }
        
        if let flightDate = data.flightDate {
            flightDateValueLabel.text = DateFormatter.dateToString(date: flightDate)
        } else {
            flightDateValueLabel.text = nil
        }
        
        if let flightTime = data.flightTime {
            flightTimeValueLabel.text = flightTime
        } else {
            flightTimeValueLabel.text = nil
        }

    }
}
