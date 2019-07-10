//
//  SynchronizationTableViewHeader.swift
//  Lufa
//
//  Created by Konrad Belzowski on 10/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

protocol SynchronizationTableViewHeaderDelegate {
    func allChecked(type: SynchronizationSectionType)
}

class SynchronizationTableViewHeader: UITableViewHeaderFooterView {
  
    //MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var allCheckbox: Checkbox!
    
    var delegate: SynchronizationTableViewHeaderDelegate?
    var sectionType: SynchronizationSectionType = .All
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setAppearance()
        loadTranslations()
    }
    
    func load(title: String, withDelegate: SynchronizationTableViewHeaderDelegate, type: SynchronizationSectionType) {
        titleLabel.text = title
        delegate = withDelegate
        sectionType = type
    }
    
    //MARK: - Appearance
    func setAppearance() {
        let background = UIView()
        background.backgroundColor = UIColor.lightGray
        
        self.backgroundView = background
    }
    
    func loadTranslations() {
        allLabel.text = "synchronization.header.all.title".localized()
    }
    
    //MARK: - Action
    @IBAction func allCheckboxAction(_ sender: Any) {
        delegate?.allChecked(type: sectionType)
    }
}
