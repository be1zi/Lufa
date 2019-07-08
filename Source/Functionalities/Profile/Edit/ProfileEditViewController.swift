//
//  ProfileEditViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 04/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class ProfileEditViewController: BaseViewController {
    
    //MARK:- Properties
    //Title
    @IBOutlet weak var firstNameTitleLabel: UILabel!
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameTitleLabel: UILabel!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var birthDateTitleLabel: UILabel!
    @IBOutlet weak var birthDateErrorLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var confirmEmailTitleLabel: UILabel!
    @IBOutlet weak var confirmEmailErrorLabel: UILabel!
    @IBOutlet weak var phoneNumberTitleLabel: UILabel!
    @IBOutlet weak var phoneNumberErrorLabel: UILabel!
    @IBOutlet weak var autoSynchronizationTitleLabel: UILabel!
    @IBOutlet weak var notificationsTitleLabel: UILabel!
    
    //Value
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    //bitrh date
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var confirmEmailTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    
    @IBOutlet weak var autoSynchronizationCheckbox: Checkbox!
    @IBOutlet weak var notificationsCheckbox: Checkbox!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var employee: Employee?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearErrors()
        loadData()
        setData()
    }
    
    //MARK: - Appearance
    override func navigationBarTitle() -> String? {
        return "profile.edit.title".localized()
    }
    
    override func constraintToBottom() -> NSLayoutConstraint? {
        return bottomConstraint
    }
    
    override func loadTranslations() {
        
        firstNameTitleLabel.text = "profile.personalData.firstName.title".localized()
        lastNameTitleLabel.text = "profile.personalData.lastName.title".localized()
        birthDateTitleLabel.text = "profile.personalData.birthDate.title".localized()
        emailTitleLabel.text = "profile.contactData.email.title".localized()
        confirmEmailTitleLabel.text = "profile.edit.email.confirm.title".localized()
        phoneNumberTitleLabel.text = "profile.contactData.phone.title".localized()
        autoSynchronizationTitleLabel.text = "profile.permissions.autoSynchronization.title".localized()
        notificationsTitleLabel.text = "profile.permissions.notifications.title".localized()
        
        firstNameTextfield.placeholder = "profile.edit.firstName.placeholder".localized()
        lastNameTextfield.placeholder = "profile.edit.lastName.placeholder".localized()
        //birthdate placeholder
        emailTextfield.placeholder = "profile.edit.email.placeholder".localized()
        confirmEmailTextfield.placeholder = "profile.edit.email.placeholder".localized()
        phoneNumberTextfield.placeholder = "profile.edit.phone.placeholder".localized()
        
        saveButton.setTitle("save.title".localized(), for: .normal)
        cancelButton.setTitle("cancel.title".localized(), for: .normal)
    }
    
    func clearErrors() {
        firstNameErrorLabel.text = nil
        lastNameErrorLabel.text = nil
        birthDateErrorLabel.text = nil
        emailErrorLabel.text = nil
        confirmEmailErrorLabel.text = nil
        phoneNumberErrorLabel.text = nil
    }
    
    //MARK: - Data
    func loadData() {
        employee = LocalRepositoryContext.sharedInstance.getEmployee()
    }
    
    func setData() {
        
        guard let employee = employee else {
            return
        }
        
        firstNameTextfield.text = employee.firstName
        lastNameTextfield.text = employee.lastName
        emailTextfield.text = employee.email
        phoneNumberTextfield.text = employee.phone
        
        autoSynchronizationCheckbox.checked = employee.autoSynchronizationEnabled()
        notificationsCheckbox.checked = employee.notificationsEnabled()
    }
    
    func validateData() -> Bool {
        return true
    }
    
    func saveData() {
        
    }
    
    //MARK:- Actions
    @IBAction func saveAction(_ sender: Any) {
        self.view.endEditing(true)
        
        if validateData() {
            saveData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}
