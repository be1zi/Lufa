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
    }
    
    //MARK: Action
    @IBAction func logoutButtonAction(_ sender: Any) {
        
        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.logout(withSuccess: { _ in
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
