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
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData()
    }
    
    //MARK: - Configuration
    func registerCells() {
        self.tableView.register(UINib(nibName: "FlightTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "FlightTableViewCell")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func navigationBarTitle() -> String? {
        return "flight.list.title".localized()
    }
    
    //MARK: Data
    override func synchronizeData() {
        super.synchronizeData()
        
        self.progressPresenter?.presentProgress(withText: nil, completion: {
            FlightCompoundSynchroManager.sharedInstance.synchronizeWithCompletion(completion: { _, _ in
                self.fetchData()
                self.progressPresenter?.hideProgress()
            }, forced: false)
        })
    }
    
    func fetchData() {
        
        if let flights = LocalRepositoryContext.sharedInstance.getAllFlights() {
            self.flights = flights
            tableView.reloadData()
        }
    }
    
    //MARK: Actions
    @IBAction func filterButtonAction(_ sender: Any) {

        let vc = UIStoryboard.init(name: "FlightFilters", bundle: nil).instantiateInitialViewController()
        
        if let vc = vc {
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
    
        let vc = UIStoryboard.init(name: "Search", bundle: nil).instantiateInitialViewController()
        
        if let vc = vc, let child = vc.children.first as? SearchViewController {
            child.delegate = self
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
}

extension FlightListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let vc = UIStoryboard.init(name: "FlightDetails", bundle: nil).instantiateInitialViewController() as? FlightDetailsViewController
        
        if let vc = vc {
            vc.flight = flights[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension FlightListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = flights[indexPath.row]
        let from = LocalRepositoryContext.sharedInstance.getCityName(shortCut: data.departureAirport)
        let to = LocalRepositoryContext.sharedInstance.getCityName(shortCut: data.arrivalAirport)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightTableViewCell", for: indexPath) as? FlightTableViewCell
        
        if let cell = cell {
            cell.loadWithData(flight: data, from: from, to: to)
            return cell
        }
        
        return UITableViewCell()
    }
}

extension FlightListViewController: SearchDelegate {
    
}
