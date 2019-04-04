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
    
        loadTranslations()
    }
    
    //MARK: Properties
    
    func loadTranslations() {
        
    }
}
