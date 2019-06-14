//
//  HomeFlightsTableViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 13/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class HomeFlightsTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var flights: [Flight] = []
    
    func setFlights(withFlights: [Flight]) {
        flights = withFlights
    }
}
