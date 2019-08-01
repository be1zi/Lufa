//
//  Picker.swift
//  Lufa
//
//  Created by Konrad Belzowski on 01/08/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class Picker: UITextField {
    
    let dataPicker = UIPickerView()
    let editIndicatorView = UIView()
    let clearButton = UIButton()
    var showIndicator: Bool = true
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
            }
            setClearButtonStyle()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupPicker()
        setupView()
        setClearButtonStyle()
    }
    
    private func setupPicker() {
        dataPicker.contentMode = .scaleAspectFit
        dataPicker.delegate = self
        dataPicker.dataSource = self
        dataPicker.showsSelectionIndicator = true
        
        inputView = dataPicker
        delegate = self
        selectedData = nil
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
        selectedData = nil
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
