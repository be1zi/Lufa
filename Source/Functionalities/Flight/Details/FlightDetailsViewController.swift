//
//  FlightDetailsViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 12/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

enum FlightDetailsCellType: Int {
    case Header = 0
    case Title
    case SectionAirport
    case Airport
    case SectionSchedule
    case Schedule
    case SectionPlaces
    case Places
    case All
}

class FlightDetailsViewController : BaseViewController {
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var flight: Flight?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        tableView.tableFooterView = view
        
        registerCells()
    }
    
    //MARK: Configurations
    func registerCells() {
        
        tableView.register(UINib(nibName: "FlightDetailsHeaderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "FlightDetailsHeaderTableViewCell")
        tableView.register(UINib(nibName: "FlightDetailsTitleTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "FlightDetailsTitleTableViewCell")
        tableView.register(UINib(nibName: "FlightDetailsSectionTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "FlightDetailsSectionTableViewCell")
        tableView.register(UINib(nibName: "FlightDetailsAirportTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "FlightDetailsAirportTableViewCell")
        tableView.register(UINib(nibName: "FlightDetailsScheduleTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "FlightDetailsScheduleTableViewCell")
        tableView.register(UINib(nibName: "FlightDetailsPlaceTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "FlightDetailsPlaceTableViewCell")
    }
}

extension FlightDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FlightDetailsCellType.All.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let flight = flight else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case FlightDetailsCellType.Header.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlightDetailsHeaderTableViewCell", for: indexPath) as? FlightDetailsHeaderTableViewCell
            
            if let cell = cell {
                return cell
            }
            
        case FlightDetailsCellType.Title.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlightDetailsTitleTableViewCell", for: indexPath) as? FlightDetailsTitleTableViewCell
            
            if let cell = cell {
                cell.loadWithData(flight: flight)
                
                return cell
            }
            
        case FlightDetailsCellType.SectionAirport.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlightDetailsSectionTableViewCell", for: indexPath) as? FlightDetailsSectionTableViewCell
            
            if let cell = cell {
                cell.loadWithName(name: "flight.details.cell.section.airport".localized())
            
                return cell
            }
            
        case FlightDetailsCellType.Airport.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlightDetailsAirportTableViewCell", for: indexPath) as? FlightDetailsAirportTableViewCell
            
            if let cell = cell {
                cell.loadWithData(flight: flight)
                
                return cell
            }
            
        case FlightDetailsCellType.SectionSchedule.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlightDetailsSectionTableViewCell", for: indexPath) as? FlightDetailsSectionTableViewCell
            
            if let cell = cell {
                cell.loadWithName(name: "flight.details.cell.section.time".localized())
                
                return cell
            }
            
        case FlightDetailsCellType.Schedule.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlightDetailsScheduleTableViewCell", for: indexPath) as? FlightDetailsScheduleTableViewCell
            
            if let cell = cell {
                cell.loadWithData(flight: flight)
                
                return cell
            }
            
        case FlightDetailsCellType.SectionPlaces.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlightDetailsSectionTableViewCell", for: indexPath) as? FlightDetailsSectionTableViewCell
            
            if let cell = cell {
                cell.loadWithName(name: "flight.details.cell.section.places".localized())
                
                return cell
            }
            
        case FlightDetailsCellType.Places.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlightDetailsPlaceTableViewCell", for: indexPath) as? FlightDetailsPlaceTableViewCell
            
            if let cell = cell {
                cell.loadWithData(flight: flight)
                
                return cell
            }
            
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
}
