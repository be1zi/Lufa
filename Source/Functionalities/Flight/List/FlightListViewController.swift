//
//  FlightListViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 11/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class FlightListViewController: BaseViewController {
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var flights: [Flight] = []
}

extension FlightListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension FlightListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightTableViewCell", for: indexPath)
        
        return cell
    }
}
