//
//  AuthorizationViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 01/04/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import UIKit

class AuthorizationViewController: BaseViewController {
    
    @IBOutlet weak var authorizeButton: UIButton!
    @IBOutlet weak var changeLanguageButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    //MARK: Properties
    
    override func loadTranslations() {
        super.loadTranslations()
        
        welcomeLabel.text = "authorization.welcome".localized()
        infoLabel.text = "authorization.message".localized()
        authorizeButton.setTitle("authorization.button.authorize.title".localized(), for: .normal)
        
        let currentLanguage = LanguageManager.sharedInstance.currentLanguage
        
        if currentLanguage == LANGUAGE_PL {
            changeLanguageButton.setTitle("authorization.button.changeLanguage.pl".localized(), for: .normal)
        } else {
            changeLanguageButton.setTitle("authorization.button.changeLanguage.en".localized(), for: .normal)
        }
    }
    
    override func shouldHideNavigationBar() -> Bool {
        return true
    }
    
    //MARK: Actions
    
    @IBAction func authorizeButtonAction(_ sender: UIButton) {
        
        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.authorizeOpen(withSuccess: { result in
                
                InitSynchroManager.sharedInstance.synchronizeWithCompletion(completion: { _, _ in
                    self.progressPresenter?.hideProgress()
                    AppDelegate.sharedInstance.windowController?.presentMenuController()
                }, forced: false)
                
            }, andFailure: { error in
                self.progressPresenter?.hideProgress()
                print("Error authorization open: \(error?.localizedDescription ?? "empty message")")
            })
        })
    }
    
    @IBAction func changeLanguageAction(_ sender: Any) {
        AppDelegate.sharedInstance.windowController?.presentLanguageController()
    }
}
