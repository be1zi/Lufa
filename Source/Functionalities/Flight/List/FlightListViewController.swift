//
//  FlightListViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 11/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FlightListViewController: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var filters: [FlightFilterItem]?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData()
    }
    
    // MARK: - Configuration
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
    
    // MARK: Data
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
        
        guard let request = LocalRepositoryContext.sharedInstance.requestForFlight(withFilters: filters) else {
            return
        }
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: LocalRepositoryContext.context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
        ((try? fetchedResultsController?.performFetch()) as ()??)
        
        tableView.reloadData()
    }
    
    // MARK: Actions
    @IBAction func filterButtonAction(_ sender: Any) {

        let vc = UIStoryboard.init(name: "FlightFilters", bundle: nil).instantiateInitialViewController()
        
        if let vc = vc, let child = vc.children.first as? FlightFiltersViewController {
            child.delegate = self
            child.filters = filters
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
        
        if let vc = vc,
            let object = fetchedResultsController?.object(at: indexPath) as? NSManagedObject,
            let flight = object.unmanagedCopy() as? Flight {
            
            vc.flight = flight
            
            LocalRepositoryContext.sharedInstance.setFlightAsViewed(key: flight.flightDesignator)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension FlightListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let object = fetchedResultsController?.object(at: indexPath) as? NSManagedObject else {
            return UITableViewCell()
        }
        
        guard let obj = object.unmanagedCopy() as? Flight else {
            return UITableViewCell()
        }
        
        let from = LocalRepositoryContext.sharedInstance.getCity(shortCut: obj.departureAirport)
        let to = LocalRepositoryContext.sharedInstance.getCity(shortCut: obj.arrivalAirport)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightTableViewCell", for: indexPath) as? FlightTableViewCell
        
        if let cell = cell {
            cell.loadWithData(flight: obj, from: from, to: to)
            return cell
        }
        
        return UITableViewCell()
    }
}

extension FlightListViewController: SearchDelegate {
    
    func searchControllerNeedsFetchRequestForLastViewedData() -> NSFetchRequest<NSFetchRequestResult>? {
        return LocalRepositoryContext.sharedInstance.requestForLastViewedFlights()
    }
    
    func searchControllerNeedsFetchRequestWithText(text: String) -> NSFetchRequest<NSFetchRequestResult>? {
        return LocalRepositoryContext.sharedInstance.requestForFlight(withText: text)
    }
    
    func searchControllerNeedsName(forObject: NSManagedObject) -> String? {
        if let object = forObject as? Flight {
            return object.flightDesignator
        } else {
            return nil
        }
    }
    
    func searchControllerNeedsSetAsViewed(objectKey: Any?) {
        
        if let key = objectKey as? String {
            LocalRepositoryContext.sharedInstance.setFlightAsViewed(key: key)
        }
    }
}

extension FlightListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        guard let index = indexPath else {
            return
        }
        
        let newIndex = newIndexPath ?? IndexPath(row: 0, section: 0)
        
        switch type {
        case .insert:
            tableView.insertRows(at: [index], with: .fade)
        case .delete:
            tableView.deleteRows(at: [index], with: .fade)
        case .move:
            tableView.deleteRows(at: [index], with: .fade)
            tableView.insertRows(at: [newIndex], with: .fade)
        case .update:
            tableView.reloadRows(at: [index], with: .fade)
        @unknown default:
            return
        }
    }
}

extension FlightListViewController: FlightFiltersDelegate {
    
    func shouldFilterWithItems(_ items: [FlightFilterItem]?) {
        filters = items
        
        fetchData()
    }
}
