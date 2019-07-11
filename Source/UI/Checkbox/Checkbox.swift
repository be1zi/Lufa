//
//  Checkbox.swift
//  Lufa
//
//  Created by Konrad Belzowski on 05/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

enum CheckboxState {
    case selected, deselected
}

class Checkbox: UIButton  {
    
    private static let checkedImage: UIImage? = {
        UIImage(named: "checkedCheckbox")
    }()
    
    private static let uncheckedImage: UIImage? = {
       UIImage(named: "uncheckedCheckbox")
    }()
    
    var checked: Bool {
        get{
            return self.backgroundImage(for: .normal) == Checkbox.checkedImage
        }
        set {
            setState(selected: newValue)
        }
    }
        
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addAction()
        setState(selected: nil)
        setStyle()
    }
    
    private func addAction() {
        if isUserInteractionEnabled {
            self.addTarget(self, action: #selector(tapAction), for: UIControl.Event.touchUpInside)
        }
    }
    
    private func setState(selected: Bool?) {
        
        var state: CheckboxState = .deselected
        
        if let selected = selected {
            state = selected ? .selected : .deselected
        } else {
            state = checked ? .selected : .deselected
        }
        
        changeState(newState: state)
    }
    
    private func setStyle() {
        self.setTitle(nil, for: .normal)
    }
    
    private func changeState(newState: CheckboxState) {

        switch newState {
        case .selected:
            self.imageView?.image = Checkbox.checkedImage
            self.setBackgroundImage(Checkbox.checkedImage, for: .normal)
        case .deselected:
            self.imageView?.image = Checkbox.uncheckedImage
            self.setBackgroundImage(Checkbox.uncheckedImage, for: .normal)
        }
    }

    //MARK: - Action
    @objc private func tapAction() {
        let newState: CheckboxState = checked ? .deselected : .selected
        changeState(newState: newState)
        
        NotificationCenter.default.post(name: .checkboxChangeState, object: newState)
    }
}
