//
//  FlightTableViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 11/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import UIKit

class FlightTableViewCell: UITableViewCell {

    //MARK: Properties
    //names
    @IBOutlet weak var airlineTitleLabel: UILabel!
    @IBOutlet weak var designatorTitleLabel: UILabel!
    @IBOutlet weak var departureTitleLabel: UILabel!
    @IBOutlet weak var arrivalTitleLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    
    //Values
    @IBOutlet weak var airlineValueLabel: UILabel!
    @IBOutlet weak var designatorValueLabel: UILabel!
    @IBOutlet weak var departureValueLabel: UILabel!
    @IBOutlet weak var arrivalValueLabel: UILabel!
    @IBOutlet weak var dateValueLabel: UILabel!
    
    var flight: Flight?
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadTranslations()
        setData()
    }
    
    //MARK: Properties
    func loadTranslations() {
        
        airlineTitleLabel.text = "flight.cell.airline.title".localized()
        designatorTitleLabel.text = "flight.cell.designator.title".localized()
        departureTitleLabel.text = "flight.cell.departure.title".localized()
        arrivalTitleLabel.text = "flight.cell.arrival.title".localized()
        dateTitleLabel.text = "flight.cell.date.title".localized()
    }
    
    //MARK: Data
    func initWithData(flight: Flight) {
        self.flight = flight
    }
    
    func setData() {
        
        if let flight = flight {
            airlineValueLabel.text = flight.operatingAirline
            designatorValueLabel.text = flight.flightDesignator
            departureValueLabel.text = flight.departureAirport
            arrivalValueLabel.text = flight.arrivalAirport
            
            if let date = flight.flightDate {
                dateValueLabel.text = DateFormatter.dateToString(date: date)
            } else {
                dateValueLabel.text = nil
            }
        }
    }
}
