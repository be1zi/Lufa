//
//  DatePicker.swift
//  Lufa
//
//  Created by Konrad Belzowski on 30/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class DatePicker: BasePicker {
    
    // MARK: Properties
    let datePicker = UIDatePicker()
    var date: Date? {
        willSet {
            if let value = newValue {
                datePicker.date = value
                text = DateFormatter.dateToString(date: value)
            } else {
                text = nil
            }
            
            setClearButtonStyle()
        }
    }
    
    override func setupPicker() {
        datePicker.datePickerMode = .date
        
        inputView = datePicker
        delegate = self
        date = nil
    }
    
    override func clear() {
        date = nil
    }
}

extension DatePicker: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        text = DateFormatter.dateToString(date: datePicker.date)
        date = datePicker.date
        
        editIndicatorView.backgroundColor = UIColor.lufaGreyColor
    }
}
