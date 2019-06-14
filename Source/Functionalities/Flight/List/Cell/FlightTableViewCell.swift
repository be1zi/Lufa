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
    @IBOutlet var airlineTitleLabel: UILabel!
    @IBOutlet var designatorTitleLabel: UILabel!
    @IBOutlet var departureTitleLabel: UILabel!
    @IBOutlet var arrivalTitleLabel: UILabel!
    @IBOutlet var dateTitleLabel: UILabel!
    
    //Values
    @IBOutlet var airlineValueLabel: UILabel!
    @IBOutlet var designatorValueLabel: UILabel!
    @IBOutlet var departureValueLabel: UILabel!
    @IBOutlet var arrivalValueLabel: UILabel!
    @IBOutlet var dateValueLabel: UILabel!
    
    var flight: Flight?
    var arrivalCity: City?
    var departureCity: City?
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        loadTranslations()
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
    func loadWithData(flight: Flight, from: City?, to: City?) {
        self.flight = flight
        self.departureCity = from
        self.arrivalCity = to
        
        setData()
    }
    
    func setData() {
        
        if let flight = flight {
            airlineValueLabel.text = flight.operatingAirline
            designatorValueLabel.text = flight.flightDesignator
            departureValueLabel.text = departureCity?.name
            arrivalValueLabel.text = arrivalCity?.name
            
            if let date = flight.flightDate {
                dateValueLabel.text = DateFormatter.dateToString(date: date)
            } else {
                dateValueLabel.text = nil
            }
        }
    }
}
