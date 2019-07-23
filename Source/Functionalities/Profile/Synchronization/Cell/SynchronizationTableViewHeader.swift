//
//  SynchronizationTableViewHeader.swift
//  Lufa
//
//  Created by Konrad Belzowski on 10/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class SynchronizationTableViewHeader: UITableViewHeaderFooterView {
  
    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var allCheckbox: Checkbox!
    
    var delegate: SynchronizationDelegate?
    var sectionType: SynchronizationSectionType = .All
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setAppearance()
        loadTranslations()
        registerForNotification()
    }
    
    deinit {
        unregisterFromNotification()
    }
    
    func load(title: String, withDelegate: SynchronizationDelegate, type: SynchronizationSectionType) {
        titleLabel.text = title
        delegate = withDelegate
        sectionType = type
    }
    
    // MARK: - Appearance
    func setAppearance() {
        let background = UIView()
        background.backgroundColor = UIColor.lightGray
        
        self.backgroundView = background
    }
    
    func loadTranslations() {
        allLabel.text = "synchronization.header.all.title".localized()
    }
    
    // MARK: - Notification
    func registerForNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(allCheckboxAction(_:)), name: .checkboxChangeState, object: nil)
    }
    
    func unregisterFromNotification() {
        NotificationCenter.default.removeObserver(self, name: .checkboxChangeState, object: nil)
    }
    
    // MARK: - Action
    @objc func allCheckboxAction(_ notification: Notification) {
        delegate?.allCheckboxChangeState(newState: allCheckbox.checked, type: sectionType)
    }
}
