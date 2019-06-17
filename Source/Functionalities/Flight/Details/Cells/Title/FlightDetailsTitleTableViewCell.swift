//
//  FlightDetailsTitleTableViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 17/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class FlightDetailsTitleTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    
    var flight: Flight?
    
    func loadWithData(flight: Flight) {
        self.flight = flight
        
        setData()
    }
    
    func setData() {
        
        guard let data = flight else {
            return
        }
        
        if let operatingAirline = data.operatingAirline,
            let flightDesignator = data.flightDesignator {
            titleLabel.text = "\(operatingAirline): \(flightDesignator)"
        }
    }
}
