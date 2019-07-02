//
//  HomeViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 29/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
import UIKit

enum HomeCellType: Int {
    case HEADER
    case FLIGHTS
    case ALL
}

class HomeViewController: BaseViewController {
    
    //MARK: Properties
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var employee: Employee?
    var flights: [Flight]?
    
    //MARK: Lifecycle
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
    
    //MARK: Appearance
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
    
    //MARK: Data
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
            }, andFailure: { error in
                self.progressPresenter?.hideProgress()
            })
        })

        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.getAllCrew(withSuccess: { _ in
                self.progressPresenter?.hideProgress()
            }, andFailure: { error in
                self.progressPresenter?.hideProgress()
            })
        })

        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.getEventsWithPeriodOfTime(from: Date.init(), to: nil, withSuccess: { _ in
                self.progressPresenter?.hideProgress()
            }, andFailure: { Error in
                self.progressPresenter?.hideProgress()
            })
        })
    }
    
    func loadData() {
        employee = LocalRepositoryContext.sharedInstance.getEmployee()
        flights = LocalRepositoryContext.sharedInstance.getTodayFlights()
    }
    
    func setData() {
        
        if let employee = employee {
            nameLabel.text = employee.fullName()
        }
        
        if let _ = flights {
            tableView.reloadData()
        }
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
        
        guard let flights = flights else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case HomeCellType.HEADER.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderTableViewCell", for: indexPath) as? HomeHeaderTableViewCell {
                cell.setCount(count: flights.count)
                return cell
            }
        case HomeCellType.FLIGHTS.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFlightsTableViewCell", for: indexPath) as? HomeFlightsTableViewCell {
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
       
        let vc = UIStoryboard.init(name: "FlightDetails", bundle: nil).instantiateInitialViewController() as? FlightDetailsViewController
        
        if let vc = vc, let flights = flights {
            vc.flight = flights[index.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
