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
        getData()
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
            RemoteRepositoryContext.sharedInstance.getAllFlight(params: nil, withSuccess: { _ in
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
        
        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.getAllCountries(withSuccess: { _ in
                self.progressPresenter?.hideProgress()
                
                print("Success get Countries")
                
            }, andFailure: { error in
                self.progressPresenter?.hideProgress()
                
                print("Error get countries")
            })
        })
        
        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.getAllCities(withOffset: 0, result: [], withSuccess: { _ in
                self.progressPresenter?.hideProgress()
                
                print("Success get Cities")
            }, andFailure: { error in
                self.progressPresenter?.hideProgress()
                
                print("Error get cities")
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
                cell.setFlights(withFlights: flights)
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
}
