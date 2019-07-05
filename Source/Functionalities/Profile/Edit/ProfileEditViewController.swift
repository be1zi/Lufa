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
    @IBOutlet weak var birthDateErrorLabel: NSLayoutConstraint!
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
    @IBOutlet weak var button: UIButton!
    
    //MARK: - Appearance
    override func navigationBarTitle() -> String? {
        return "profile.edit.title".localized()
    }
}
