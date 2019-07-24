//
//  HomeViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 29/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
import UIKit
import CoreData

enum HomeCellType: Int {
    case HEADER
    case FLIGHTS
    case ALL
}

class HomeViewController: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var employee: Employee?
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        loadData()
        setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
        setData()
    }
    
    // MARK: Appearance
    override func shouldHideNavigationBar() -> Bool {
        return true
    }
    
    override func loadTranslations() {
        welcomeLabel.text = "home.welcome.title".localized()
    }
    
    func registerCells() {
        self.tableView.register(UINib(nibName: "HomeHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeHeaderTableViewCell")
        self.tableView.register(UINib(nibName: "HomeFlightsTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeFlightsTableViewCell")
    }
    
    // MARK: Data
    override func synchronizeData() {
        self.progressPresenter?.presentProgress(withText: nil, completion: {
            FlightSynchroManager.sharedInstance.synchronizeWithCompletion(completion: { _, _ in
                print("Synchronization complited: Flights")
                self.progressPresenter?.hideProgress()
            }, forced: false)
        })
    }
    
    func getData() {
        
        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.getCheckIn(params: nil, withSuccess: { _ in
                self.progressPresenter?.hideProgress()
            }, andFailure: { _ in
                self.progressPresenter?.hideProgress()
            })
        })

        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.getEventsWithPeriodOfTime(from: Date.init(), to: nil, withSuccess: { _ in
                self.progressPresenter?.hideProgress()
            }, andFailure: { _ in
                self.progressPresenter?.hideProgress()
            })
        })
    }
    
    func loadData() {
        employee = LocalRepositoryContext.sharedInstance.getEmployee()
        
        guard let request = LocalRepositoryContext.sharedInstance.getTodayFlights() else {
            return
        }
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: LocalRepositoryContext.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController?.delegate = self
        ((try? fetchedResultsController?.performFetch()) as ()??)
    }
    
    func setData() {
        
        if let employee = employee {
            nameLabel.text = employee.fullName()
        }
        
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case HomeCellType.FLIGHTS.rawValue:
            return 310
        default:
            return UITableView.automaticDimension
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeCellType.ALL.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let objects = fetchedResultsController?.fetchedObjects as? [Flight] else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case HomeCellType.HEADER.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderTableViewCell", for: indexPath) as? HomeHeaderTableViewCell {
                cell.setCount(count: objects.count)
                return cell
            }
        case HomeCellType.FLIGHTS.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFlightsTableViewCell", for: indexPath) as? HomeFlightsTableViewCell {
                cell.setData(withFlights: objects, andDelegate: self)
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
}

extension HomeViewController: HomeFlightsTableViewDelegate {
    
    func collectionViewElementSelected(atIndex index: IndexPath) {
       
        let vc = UIStoryboard.init(name: "FlightDetails", bundle: nil).instantiateInitialViewController() as? FlightDetailsViewController
        
        if let vc = vc, let object = fetchedResultsController?.object(at: index) as? Flight {
            vc.flight = object
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController: NSFetchedResultsControllerDelegate {
    
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
