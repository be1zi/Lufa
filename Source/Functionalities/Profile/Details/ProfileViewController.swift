//
//  ProfileViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 11/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: BaseViewController {
    
    // MARK: Properties
    //Names
    @IBOutlet weak var personalDataLabel: UILabel!
    @IBOutlet weak var firstNameTitleLabel: UILabel!
    @IBOutlet weak var lastNameTitleLabel: UILabel!
    @IBOutlet weak var birthDateTitleLabel: UILabel!
    @IBOutlet weak var contactDataTitleLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var jobDataTitleLabel: UILabel!
    @IBOutlet weak var positionTitleLabel: UILabel!
    @IBOutlet weak var dutyTitleLabel: UILabel!
    @IBOutlet weak var permissionsTitleLabel: UILabel!
    @IBOutlet weak var autoSynchronizationTitleLabel: UILabel!
    @IBOutlet weak var notificationsTitleLabel: UILabel!
    
    //Values
    @IBOutlet weak var firstNameValueLabel: UILabel!
    @IBOutlet weak var lastNameValueLabel: UILabel!
    @IBOutlet weak var birthDateValueLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var phoneValueLabel: UILabel!
    @IBOutlet weak var positionValueLabel: UILabel!
    @IBOutlet weak var dutyValueLabel: UILabel!
    @IBOutlet weak var autoSynchronizationCheckbox: Checkbox!
    @IBOutlet weak var notificationsCheckbox: Checkbox!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    var employee: Employee?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        loadData()
        setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        loadData()
        setData()
    }
    
    // MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func navigationBarTitle() -> String? {
        return "profile.title".localized()
    }
    
    override func shouldHideBackButton() -> Bool {
        return true
    }
    
    override func loadTranslations() {
        
        personalDataLabel.text = "profile.personalData.title".localized()
        firstNameTitleLabel.text = "profile.personalData.firstName.title".localized()
        lastNameTitleLabel.text = "profile.personalData.lastName.title".localized()
        birthDateTitleLabel.text = "profile.personalData.birthDate.title".localized()
        
        contactDataTitleLabel.text = "profile.contactData.title".localized()
        emailTitleLabel.text = "profile.contactData.email.title".localized()
        phoneTitleLabel.text = "profile.contactData.phone.title".localized()
        
        jobDataTitleLabel.text = "profile.jobData.title".localized()
        positionTitleLabel.text = "profile.jobData.position.title".localized()
        dutyTitleLabel.text = "profile.jobData.duty.title".localized()
        
        permissionsTitleLabel.text = "profile.permissions.title".localized()
        autoSynchronizationTitleLabel.text = "profile.permissions.autoSynchronization.title".localized()
        notificationsTitleLabel.text = "profile.permissions.notifications.title".localized()
        
        logoutButton.setTitle("logout.title".localized(), for: .normal)
    }
    
    func configure() {
        autoSynchronizationCheckbox.isUserInteractionEnabled = false
        notificationsCheckbox.isUserInteractionEnabled = false
    }
    
    func loadData() {
        employee = LocalRepositoryContext.sharedInstance.getEmployee()
    }
    
    func setData() {
        
        guard let employee = employee else {
            return
        }
        
        firstNameValueLabel.text = employee.firstName
        lastNameValueLabel.text = employee.lastName
            
        if let birthDate = employee.birthDate {
            birthDateValueLabel.text = DateFormatter.dateToString(date: birthDate)
        } else {
            birthDateValueLabel.text = nil
        }
            
        emailValueLabel.text = employee.email
        phoneValueLabel.text = employee.phone
        positionValueLabel.text = employee.crewPosition
        dutyValueLabel.text = employee.dutyCode
        
        autoSynchronizationCheckbox.checked = employee.autoSynchronizationEnabled()
        notificationsCheckbox.checked = employee.notificationsEnabled()
    }
    
    // MARK: Action
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.logout(withSuccess: { _ in
                
                LocalRepositoryContext.sharedInstance.clearDataBase()
                AppDelegate.sharedInstance.removeAuthorizationToken()
                AppDelegate.sharedInstance.removeAuthorizationOpenToken()
                AppDelegate.sharedInstance.windowController?.presentAuthorizationController()
                
                self.progressPresenter?.hideProgress()
                
            }, andFailure: { error in
                self.progressPresenter?.hideProgress()
                print("ERROR logout: \(error ?? "" as Any) , \(error?.localizedDescription ?? "" as Any)")
            })
        })
    }
    
    @IBAction func editAccountButtonAction(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "ProfileEdit", bundle: nil).instantiateInitialViewController()
        
        if let vc = vc {
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func synchronizeButtonAction(_ sender: Any) {
    
        let vc = UIStoryboard.init(name: "Synchronization", bundle: nil).instantiateInitialViewController()
        
        if let vc = vc {
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
}
