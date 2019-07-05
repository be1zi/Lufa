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
    
    //Value
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    //bitrh date
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var confirmEmailTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    
    @IBOutlet weak var autoSynchronizationButton: Checkbox!
    @IBOutlet weak var notificationsButton: Checkbox!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearErrors()
    }
    
    //MARK: - Appearance
    override func navigationBarTitle() -> String? {
        return "profile.edit.title".localized()
    }
    
    func clearErrors() {
        firstNameErrorLabel.text = nil
        lastNameErrorLabel.text = nil
        birthDateErrorLabel.text = nil
        emailErrorLabel.text = nil
        confirmEmailErrorLabel.text = nil
        phoneNumberErrorLabel.text = nil
    }
}
