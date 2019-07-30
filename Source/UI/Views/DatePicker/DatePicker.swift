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
    var date: Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupPicker()
        setupView()
        setClearButtonStyle()
    }
    
    func setupPicker() {
        datePicker.datePickerMode = .date
        
        inputView = datePicker
        delegate = self
        date = nil
    }
    
    func setupView() {
        borderStyle = .none
        tintColor = UIColor.lufaGreenColor
        
        editIndicatorView.backgroundColor = UIColor.lufaGreyColor
        self.addSubview(editIndicatorView)

        clearButton.setImage(UIImage(named: "cancel"), for: .normal)
        clearButton.addTarget(self, action: #selector(shouldClear), for: .touchUpInside)
        rightView = clearButton
        rightViewMode = .unlessEditing
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        editIndicatorView.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.maxY, width: self.frame.size.width, height: 2)
        
        let clearButtonSize = self.frame.size.height
        clearButton.frame = CGRect.init(x: self.frame.maxX - clearButtonSize - 5, y: self.frame.origin.y, width: clearButtonSize, height: clearButtonSize)
        clearButton.center.y = self.center.y
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
    
    @objc func shouldClear() {
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
