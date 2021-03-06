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
    
    // MARK: Properties
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
    @IBOutlet weak var birthDateDatePicker: DatePicker!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var confirmEmailTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    
    @IBOutlet weak var autoSynchronizationCheckbox: Checkbox!
    @IBOutlet weak var notificationsCheckbox: Checkbox!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var employee: Employee?
    var requiredErrorMessage: String?
    var emailNotTheSameErrorMessage: String?
    var wrongEmailPatternErrorMessage: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearErrors()
        loadData()
        setData()
        setDelegates()
        setConfigurations()
    }
    
    // MARK: - Appearance
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
        birthDateDatePicker.placeholder = "profile.edit.birthdate.placeholder".localized()
        emailTextfield.placeholder = "profile.edit.email.placeholder".localized()
        confirmEmailTextfield.placeholder = "profile.edit.email.placeholder".localized()
        phoneNumberTextfield.placeholder = "profile.edit.phone.placeholder".localized()
        
        requiredErrorMessage = "profile.edit.error.required.title".localized()
        emailNotTheSameErrorMessage = "profile.edit.error.email.notTheSame.title".localized()
        wrongEmailPatternErrorMessage = "profile.edit.error.email.wrong.title".localized()
        
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
    
    func setDelegates() {
        firstNameTextfield.delegate = self
        lastNameTextfield.delegate = self
        emailTextfield.delegate = self
        confirmEmailTextfield.delegate = self
        phoneNumberTextfield.delegate = self
    }
    
    func setConfigurations() {
        birthDateDatePicker.showIndicator = false
    }
    
    // MARK: - Data
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
        birthDateDatePicker.date = employee.birthDate
        
        autoSynchronizationCheckbox.checked = employee.autoSynchronizationEnabled()
        notificationsCheckbox.checked = employee.notificationsEnabled()
    }
    
    func validateData() -> Bool {
        
        var allValidate = true
        
        if !checkIfEmptyTextField(textfield: firstNameTextfield,
                                  errorLabel: firstNameErrorLabel,
                                  errorMessage: requiredErrorMessage) {
            allValidate = false
        }
        
        if !checkIfEmptyTextField(textfield: lastNameTextfield,
                                  errorLabel: lastNameErrorLabel,
                                  errorMessage: requiredErrorMessage) {
            allValidate = false
        }
        
        if !checkIfEmptyTextField(textfield: emailTextfield,
                                  errorLabel: emailErrorLabel,
                                  errorMessage: requiredErrorMessage) {
            allValidate = false
        } else if !validateEmail() {
            allValidate = false
        }
        
        if !checkIfEmptyTextField(textfield: phoneNumberTextfield,
                                  errorLabel: phoneNumberErrorLabel,
                                  errorMessage: requiredErrorMessage) {
            allValidate = false
        }
        
        return allValidate
    }
    
    func checkIfEmptyTextField(textfield: UITextField, errorLabel: UILabel, errorMessage: String?) -> Bool {
        
        var result: Bool = true
        
        if let text = textfield.text {
            if text.isEmpty {
                errorLabel.text = errorMessage
                result = false
            }
        } else {
            errorLabel.text = errorMessage
            result = false
        }
        
        return result
    }
    
    func validateEmail() -> Bool {
    
        let currentEmail = employee?.email
        
        if emailTextfield.text == currentEmail ||
            
            emailTextfield.text == confirmEmailTextfield.text {
            return true
        
        } else if !Regex.isValidEmail(email: emailTextfield.text) {
            
            emailErrorLabel.text = wrongEmailPatternErrorMessage
            return false
        
        } else {
            
            emailErrorLabel.text = emailNotTheSameErrorMessage
            confirmEmailErrorLabel.text = emailNotTheSameErrorMessage
            return false
        
        }
    }
    
    func saveData() {
        let data = prepareData()
        let permissions = preparePermissions()
        
        LocalRepositoryContext.sharedInstance.updateEmployee(withData: data, permissions: permissions)
    }
    
    func prepareData() -> [String: Any] {
        var data: [String: Any] = [:]
    
        data["firstName"] = firstNameTextfield.text
        data["lastName"] = lastNameTextfield.text
        data["email"] = emailTextfield.text
        data["birthDate"] = birthDateDatePicker.date
        
        return data
    }
    
    func preparePermissions() -> [[String: Any]] {
        var permissions: [[String: Any]] = []
        
        permissions.append(["name": PermissionType.AutoSynchronization.rawValue,
                            "value": autoSynchronizationCheckbox.checked])
        permissions.append(["name": PermissionType.Notifications.rawValue,
                            "value": notificationsCheckbox.checked])
        
        return permissions
    }
    
    // MARK: Actions
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

extension ProfileEditViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let digits = NSCharacterSet.decimalDigits
        let letters = NSCharacterSet.letters
        
        if range.length == 1 {
            return true
        }
        
        if textField == firstNameTextfield || textField == lastNameTextfield {
            if !letters.isSuperset(of: CharacterSet(charactersIn: string)) {
                return false
            }
        }
        
        if textField == phoneNumberTextfield {
            if !digits.isSuperset(of: CharacterSet(charactersIn: string)) {
                return false
            }
            
            if let text = textField.text,
                text.count < Constants.PHONE_NUMBER_LENGTH {
                return true
            } else {
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameTextfield {
            lastNameTextfield.becomeFirstResponder()
        } else if textField == lastNameTextfield {
            emailTextfield.becomeFirstResponder()
        } else if textField == emailTextfield {
            confirmEmailTextfield.becomeFirstResponder()
        } else if textField == confirmEmailTextfield {
            phoneNumberTextfield.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
