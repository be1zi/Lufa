//
//  SynchronizationTableViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 09/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class SynchronizationTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    var delegate: SynchronizationDelegate?
    var sectionType: SynchronizationSectionType?
    var synchroType: SynchroType?
    
    //MARK: - Lifecycle
    func load(title: String, on: Bool, withDelegate: SynchronizationDelegate, section: SynchronizationSectionType?, synchro: SynchroType?) {
        titleLabel.text = title
        switchButton.isOn = on
        delegate = withDelegate
        sectionType = section
        synchroType = synchro
    }
    
    //MARK: - Action
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.checkboxChangeState(newState: switchButton.isOn, section: sectionType!, type: synchroType!)
    }
}
