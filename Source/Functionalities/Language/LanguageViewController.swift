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
    
    //MAKR: Properties
    
    override func loadTranslations() {
        super.loadTranslations()
    }
    
    override func shouldHideNavigationBar() -> Bool {
        return true
    }
    
    //MARK: Actions
    
    @IBAction func polishButtonAction(_ sender: UIButton) {
        LanguageManager.sharedInstance.currentLanguage = LANGUAGE_PL
        
        AppDelegate.sharedInstance.windowController?.presentAuthorizationController()
    }
    
    @IBAction func englishButtonAction(_ sender: Any) {
        LanguageManager.sharedInstance.currentLanguage = LANGUAGE_EN
        
        AppDelegate.sharedInstance.windowController?.presentAuthorizationController()
    }
}
