//
//  FlightFiltersViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 04/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class FlightFiltersViewController: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadTranslations() {
        resetButton.title = "fligth.filters.reset".localized()
    }
    
    // MARK: Appearance
    override func navigationBarTitle() -> String? {
        return "flight.filters.title".localized()
    }
    
    // MARK: Actions
    @IBAction func backButtonAction(_ sender: Any) {
        view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
    
    }
}
