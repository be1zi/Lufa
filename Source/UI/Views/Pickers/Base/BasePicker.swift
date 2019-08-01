//
//  BasePicker.swift
//  Lufa
//
//  Created by Konrad Belzowski on 01/08/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class BasePicker: UITextField {
    
    let editIndicatorView = UIView()
    let clearButton = UIButton()
    var showIndicator: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupPicker()
        setupView()
        setClearButtonStyle()
    }
    
    func setupPicker() {
        
    }
    
    private func setupView() {
        tintColor = UIColor.lufaGreenColor
        
        if showIndicator {
            editIndicatorView.backgroundColor = UIColor.lufaGreyColor
            self.addSubview(editIndicatorView)
        }
        
        clearButton.setImage(UIImage(named: "cancel"), for: .normal)
        clearButton.addTarget(self, action: #selector(shouldClear), for: .touchUpInside)
        rightView = clearButton
        rightViewMode = .unlessEditing
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if showIndicator {
            editIndicatorView.frame = CGRect.init(x: 0, y: self.bounds.height, width: self.bounds.width, height: 2)
        }
        
        let clearButtonSize = self.frame.size.height
        clearButton.frame = CGRect.init(x: self.frame.maxX - clearButtonSize - 5, y: self.bounds.height/2 - clearButtonSize/2, width: clearButtonSize, height: clearButtonSize)
    }
    
    func setClearButtonStyle() {
        
        guard let value = text else {
            clearButton.isHidden = true
            
            return
        }
        
        if value.isEmpty {
            clearButton.isHidden = true
        } else {
            clearButton.isHidden = false
        }
    }
    
    @objc private func shouldClear() {
        text = nil
        clear()
    }
    
    func clear() {

    }
}

extension Picker: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editIndicatorView.backgroundColor = UIColor.lufaGreenColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editIndicatorView.backgroundColor = UIColor.lufaGreyColor
    }
}
