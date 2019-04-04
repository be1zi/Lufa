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
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: Properties
    
    override func loadTranslations() {
        super.loadTranslations()
        
        titleLabel.text = "authorization.title".localized()
        infoLabel.text = "authorization.message".localized()
        authorizeButton.setTitle("authorization.button.authorize.title".localized(), for: .normal)
        
        let currentLanguage = LanguageManager.sharedInstance.currentLanguage
        
        if currentLanguage == LANGUAGE_PL {
            changeLanguageButton.setTitle("authorization.button.changeLanguage.pl".localized(), for: .normal)
        } else {
            changeLanguageButton.setTitle("authorization.button.changeLanguage.en".localized(), for: .normal)
        }
    }
    
    //MARK: Actions
    
    @IBAction func authorizeButtonAction(_ sender: UIButton) {
        
        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.authorize(withSuccess: { result in
                AppDelegate.sharedInstance.windowController?.presentHomeController()
                self.progressPresenter?.hideProgress()
            }) { error in
                print("Error authorization: \(error?.localizedDescription ?? "empty message")")
                self.progressPresenter?.hideProgress()
            }
        })
    }
    
    @IBAction func changeLanguageAction(_ sender: Any) {
        AppDelegate.sharedInstance.windowController?.presentLanguageController()
    }
}
