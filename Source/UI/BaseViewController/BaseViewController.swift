//
//  BaseViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 22/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController {
    
    //MARK: Variables
    
    lazy var progressPresenter: ProgressPresenter? = {
        return ProgressPresenter.init(viewVontroller: self)
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        synchronizeData()
        loadConfigurations()
        loadTranslations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        synchronizeData()
        loadConfigurations()
    }
    
    //MARK: Properties
    
    func loadConfigurations() {
        
        let navigationBarHidden = shouldHideNavigationBar()
        self.navigationController?.setNavigationBarHidden(navigationBarHidden, animated: true)
        
        let backButton = UIBarButtonItem()
        navigationItem.backBarButtonItem = backButton
        
        self.title = navigationBarTitle()
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lufaGreenColor]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationController?.navigationBar.tintColor = UIColor.lufaGreenColor
        
        navigationController?.navigationItem.setHidesBackButton(shouldHideBackButton(), animated: false)
    }
    
    func loadTranslations() {
        
    }
    
    func navigationBarTitle() -> String? {
        return nil
    }
    
    func shouldHideNavigationBar() -> Bool {
        return false
    }
    
    func shouldHideBackButton() -> Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK: Data
    
    func synchronizeData() {
        
    }
}
