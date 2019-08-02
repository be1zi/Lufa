//
//  FlightDetailsTitleTableViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 17/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

protocol FlightDetailsTitleCellDelegate {
    
    func showOnMapAction()
}

class FlightDetailsTitleTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showOnMapView: UIView!
    @IBOutlet weak var showLabel: UILabel!
    
    var flight: Flight?
    var delegate: FlightDetailsTitleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showOnMap))
        showOnMapView.addGestureRecognizer(tap)
    }
    
    func loadWithData(flight: Flight, delegate: FlightDetailsTitleCellDelegate?) {
        self.flight = flight
        self.delegate = delegate
        
        setData()
        setTranslations()
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
    
    func setTranslations() {
        showLabel.text = "show.title".localized()
    }
    
    // MARK: - Action
    @objc func showOnMap() {

        if let delegate = delegate {
            delegate.showOnMapAction()
        }
    }
}
