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
    @IBOutlet weak var logoutButton: UIButton!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    //MARK: Data
    
    func getData() {
        
        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.getEventsWithPeriodOfTime(from: Date.init(), to: nil, withSuccess: { _ in
                self.progressPresenter?.hideProgress()
            }, andFailure: { error in
                self.progressPresenter?.hideProgress()
                print("ERROR get event: \(error ?? "" as Any) , \(error?.localizedDescription ?? "" as Any)")
            })
        })
        
        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.getCheckIn(params: [:], withSuccess: { _ in
                self.progressPresenter?.hideProgress()
            }, andFailure: { error in
                self.progressPresenter?.hideProgress()
                print("ERROR get checkIn: \(error ?? "" as Any), \(error?.localizedDescription ?? "" as Any)")
            })
        })
        
        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.getAllFlight(params: nil, withSuccess: { _ in
                self.progressPresenter?.hideProgress()
            }, andFailure: { error in
                print("ERROR get flight: \(error ?? "" as Any), \(error?.localizedDescription ?? "" as Any)")
                
                RemoteRepositoryContext.sharedInstance.getAllCrew(withSuccess: { _ in
                    self.progressPresenter?.hideProgress()
                }, andFailure: { error in
                    self.progressPresenter?.hideProgress()
                    print("ERROR get crew: \(error ?? "" as Any), \(error?.localizedDescription ?? "" as Any)")
                    
                    if let result = LocalRepositoryContext.sharedInstance.getCrewForFlight(flightDesignator: "LH100") {
                        print(result.crewMembers)
                    }
                })
            })
        })
    }
    
    //MARK: Action
    @IBAction func logoutButtonAction(_ sender: Any) {
        
        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.logout(withSuccess: { _ in
                
                LocalRepositoryContext.sharedInstance.clearDataBase()
                AppDelegate.sharedInstance.removeAuthorizationToken()
                AppDelegate.sharedInstance.windowController?.presentAuthorizationController()
                
                self.progressPresenter?.hideProgress()
                
            }, andFailure: { error in
                self.progressPresenter?.hideProgress()
                print("ERROR logout: \(error ?? "" as Any) , \(error?.localizedDescription ?? "" as Any)")
            })
        })
    }
}
