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
    case TodaysHeader
    case Todays
    case ElseHeader
    case Else
    case All
}

class HomeViewController: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var employee: Employee?
    var todaysFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var elseFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
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
        
        guard let todayRequest = LocalRepositoryContext.sharedInstance.getTodayFlights(),
            let elseRequest = LocalRepositoryContext.sharedInstance.getElseInWeekFlights() else {
            return
        }
        
        todaysFetchedResultsController = NSFetchedResultsController(fetchRequest: todayRequest, managedObjectContext: LocalRepositoryContext.context, sectionNameKeyPath: nil, cacheName: nil)
        elseFetchedResultsController = NSFetchedResultsController(fetchRequest: elseRequest, managedObjectContext: LocalRepositoryContext.context, sectionNameKeyPath: nil, cacheName: nil)
        
        todaysFetchedResultsController?.delegate = self
        elseFetchedResultsController?.delegate = self
        
        ((try? todaysFetchedResultsController?.performFetch()) as ()??)
        ((try? elseFetchedResultsController?.performFetch()) as ()??)
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
        case HomeCellType.Todays.rawValue:
            return 310
        case HomeCellType.Else.rawValue:
            return 310
        default:
            return UITableView.automaticDimension
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeCellType.All.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var objects: [Flight]?
        
        switch indexPath.row {
        case HomeCellType.TodaysHeader.rawValue:
            fallthrough
        case HomeCellType.Todays.rawValue:
            objects = todaysFetchedResultsController?.fetchedObjects as? [Flight]
        case HomeCellType.ElseHeader.rawValue:
            fallthrough
        case HomeCellType.Else.rawValue:
            objects = elseFetchedResultsController?.fetchedObjects as? [Flight]
        default:
            objects = []
        }
        
        switch indexPath.row {
        case HomeCellType.TodaysHeader.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderTableViewCell", for: indexPath) as? HomeHeaderTableViewCell,
                let flights = objects {
                cell.setData(count: flights.count, type: .TodaysHeader)
                return cell
            }
        case HomeCellType.ElseHeader.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderTableViewCell", for: indexPath) as? HomeHeaderTableViewCell,
                let flights = objects {
                cell.setData(count: flights.count, type: .ElseHeader)
                return cell
            }
        case HomeCellType.Todays.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFlightsTableViewCell", for: indexPath) as? HomeFlightsTableViewCell,
                let flights = objects {
                cell.setData(withFlights: flights, andDelegate: self)
                return cell
            }
        case HomeCellType.Else.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFlightsTableViewCell", for: indexPath) as? HomeFlightsTableViewCell,
                let flights = objects {
                cell.setData(withFlights: flights, andDelegate: self)
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
       
//        let vc = UIStoryboard.init(name: "FlightDetails", bundle: nil).instantiateInitialViewController() as? FlightDetailsViewController
//
//        if let vc = vc, let object = fetchedResultsController?.object(at: index) as? Flight {
//            vc.flight = object
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
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
