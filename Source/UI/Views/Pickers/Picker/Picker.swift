//
//  Picker.swift
//  Lufa
//
//  Created by Konrad Belzowski on 01/08/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class Picker: BasePicker {
    
    // MARK: Properties
    let dataPicker = UIPickerView()
    var data: (keys: [String], values: [String])? {
        willSet {
            dataPicker.reloadAllComponents()
            keys = newValue?.keys
            values = newValue?.values
        }
    }
    
    private var keys: [String]?
    private var values: [String]?
    private var selectedIndex: Int = 0 {
        willSet {
            selectedData = keys?[newValue]
        }
    }
    
    var selectedData: String? {
        willSet {
            if let value = newValue {
                let index = keys?.firstIndex(of: value)
                
                if let idx = index {
                    text = values?[idx]
                }
            } else {
                text = nil
            }
            setClearButtonStyle()
        }
    }
    
    // MARK: Functions
    override func setupPicker() {
        dataPicker.contentMode = .scaleAspectFit
        dataPicker.delegate = self
        dataPicker.dataSource = self
        dataPicker.showsSelectionIndicator = true
        
        inputView = dataPicker
        delegate = self
        selectedData = nil
    }
    
    override func clear() {
        selectedData = nil
    }
}

extension Picker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let count = values?.count else {
            return 0
        }
        
        return count
    }
}

extension Picker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values?[row]
    }
}
