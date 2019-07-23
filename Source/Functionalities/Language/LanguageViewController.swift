//
//  LanguageViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 04/04/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class LanguageViewController: BaseViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var polishButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    
    // MARK: Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
    }
    
    //MAKR: Properties
    
    override func loadTranslations() {
        super.loadTranslations()
        
        self.polishButton.setTitle("language.button.polish".localized(), for: .normal)
        self.englishButton.setTitle("language.button.english".localized(), for: .normal)
        self.infoLabel.text = "language.message".localized()
    }
    
    override func shouldHideNavigationBar() -> Bool {
        return true
    }
    
    private func setStyle() {
        
        if LanguageManager.sharedInstance.selected {
            
            let selectedPL = LanguageManager.sharedInstance.currentLanguage == LANGUAGE_PL
            
            polishButton.setStyle(selected: selectedPL)
            englishButton.setStyle(selected: !selectedPL)
        }
    }
    
    // MARK: Actions
    
    @IBAction func polishButtonAction(_ sender: UIButton) {
        LanguageManager.sharedInstance.currentLanguage = LANGUAGE_PL
        
        AppDelegate.sharedInstance.windowController?.presentAuthorizationController()
    }
    
    @IBAction func englishButtonAction(_ sender: Any) {
        LanguageManager.sharedInstance.currentLanguage = LANGUAGE_EN
                
        AppDelegate.sharedInstance.windowController?.presentAuthorizationController()
    }
}
