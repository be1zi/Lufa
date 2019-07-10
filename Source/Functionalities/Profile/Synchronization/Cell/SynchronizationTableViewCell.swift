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
    
    //MARK: - Lifecycle
    func load(title: String, on: Bool) {
        titleLabel.text = title
        switchButton.isOn = on
    }
    
    //MARK: - Action
    @IBAction func switchValueChanged(_ sender: Any) {
    
    }
}
