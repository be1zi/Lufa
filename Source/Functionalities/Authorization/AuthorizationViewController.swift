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
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotifications()
    }
    
    deinit {
        removeFromNotifications()
    }
    
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
        RemoteRepositoryContext.sharedInstance.authorize()
    }
    
    @IBAction func changeLanguageAction(_ sender: Any) {
        AppDelegate.sharedInstance.windowController?.presentLanguageController()
    }
    
    @objc func shouldAuthenticate(_ notification: Notification) {

        guard let code = notification.object as? String else {
            return
        }
        
        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.authenticate(withCode: code, success: { _ in
                RemoteRepositoryContext.sharedInstance.authorizeOpen(withSuccess: { _ in
                    
                    InitCompoundSynchroManager.sharedInstance.synchronizeWithCompletion(completion: { result, _ in
                        self.progressPresenter?.hideProgress()
                        
                        //if result != SynchroResult.SynchroResultError {
                            AppDelegate.sharedInstance.windowController?.presentMenuController()
                        //}
                        
                    }, forced: false)
                    
                }, andFailure: { error in
                    self.progressPresenter?.hideProgress()
                    print("Error authorization open: \(error?.localizedDescription ?? "empty message")")
                })
            }, failure: { error in
                self.progressPresenter?.hideProgress()
                print("Error authenticate: \(error?.localizedDescription ?? "empty message")")
            })
        })

    }
    
    //MARK: Notifications
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(shouldAuthenticate(_:)), name: .authenticateDidFinish, object: nil)
    }
    
    func removeFromNotifications() {
        NotificationCenter.default.removeObserver(self, name: .authenticateDidFinish, object: nil)
    }
}
