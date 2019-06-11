//
//  HomeViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 29/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//
import UIKit

class HomeViewController: BaseViewController {
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    //MARK: Data
    
    func getData() {
        
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
}
