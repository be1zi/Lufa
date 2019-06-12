//
//  HomeViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 29/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
import UIKit

class HomeViewController: BaseViewController {
    
    //MARK: Properties
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var employee: Employee?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
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
            RemoteRepositoryContext.sharedInstance.getAllCities(withSuccess: { _ in
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
    }
    
    func setData() {
        
        if let employee = employee {
            nameLabel.text = employee.fullName()
        }
    }
}
