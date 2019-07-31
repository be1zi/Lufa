//
//  DatePicker.swift
//  Lufa
//
//  Created by Konrad Belzowski on 30/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class DatePicker: UITextField {
    
    let datePicker = UIDatePicker()
    let editIndicatorView = UIView()
    let clearButton = UIButton()
    var showIndicator: Bool = true
    var date: Date? {
        willSet {
            if let value = newValue {
                datePicker.date = value
                text = DateFormatter.dateToString(date: value)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupPicker()
        setupView()
        setClearButtonStyle()
    }
    
    private func setupPicker() {
        datePicker.datePickerMode = .date
        
        inputView = datePicker
        delegate = self
        date = nil
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
    
    private func setClearButtonStyle() {
        
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
        date = nil
        
        setClearButtonStyle()
    }
}

extension DatePicker: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editIndicatorView.backgroundColor = UIColor.lufaGreenColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        text = DateFormatter.dateToString(date: datePicker.date)
        date = datePicker.date
        
        editIndicatorView.backgroundColor = UIColor.lufaGreyColor
        setClearButtonStyle()
    }
}
