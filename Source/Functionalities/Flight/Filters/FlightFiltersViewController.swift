//
//  FlightFiltersViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 04/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit
import TTRangeSlider

protocol FlightFiltersDelegate {
    func shouldFilterWithItems(_ items: [FlightFilterItem]?)
}

class FlightFiltersViewController: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromDatePicker: DatePicker!
    @IBOutlet weak var toDatePicker: DatePicker!
    
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var placeFromLabel: UILabel!
    @IBOutlet weak var placeToLabel: UILabel!
    @IBOutlet weak var fromPlacePicker: Picker!
    @IBOutlet weak var toPlacePicker: Picker!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeAllButton: UIButton!
    @IBOutlet weak var typeLocalButton: UIButton!
    @IBOutlet weak var typeInternationalButton: UIButton!
    
    @IBOutlet weak var travelLabel: UILabel!
    @IBOutlet weak var rangeSlider: TTRangeSlider!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var delegate: FlightFiltersDelegate?
    var filters: [FlightFilterItem]?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultsProperties()
        setPickersData()
        setFilters()
    }
    
    // MARK: Properties
    override func navigationBarTitle() -> String? {
        return "flight.filters.title".localized()
    }
    
    override func constraintToBottom() -> NSLayoutConstraint? {
        return bottomConstraint
    }
    
    override func loadTranslations() {
        resetButton.title = "fligth.filters.reset".localized()
        backButton.title = "cancel.title".localized()
        applyButton.setTitle("apply.title".localized(), for: .normal)
        
        dateLabel.text = "flight.filters.date.title".localized()
        fromLabel.text = "from.time.title".localized()
        toLabel.text = "to.time.title".localized()
        
        placeLabel.text = "flight.filters.place.title".localized()
        placeFromLabel.text = "from.place.title".localized()
        placeToLabel.text = "to.place.title".localized()
        
        typeLabel.text = "flight.filters.type.title".localized()
        typeAllButton.setTitle("all.title".localized(), for: .normal)
        typeLocalButton.setTitle("flight.filters.type.local.title".localized(), for: .normal)
        typeInternationalButton.setTitle("flight.filters.type.international.title".localized(), for: .normal)
        
        travelLabel.text = "flight.filters.travel.title".localized()
    }
    
    func setFilters() {
        
        guard let items = filters else {
            return
        }
        
        for item in items {
            
            switch item.type {
            case .date:
                fromDatePicker.date = item.values[.min] as? Date
                toDatePicker.date = item.values[.max] as? Date
            case .place:
                fromPlacePicker.selectedData = item.values[.min] as? String
                toPlacePicker.selectedData = item.values[.max] as? String
            case .travelTime:
                if let value = item.values[.min] as? Float {
                    rangeSlider.selectedMinimum = value
                }
                
                if let value = item.values[.max] as? Float {
                    rangeSlider.selectedMaximum = value
                }
            case .type:
                if let value = item.values[.value] as? String {
                    if value == "flight.filters.type.local.title" {
                        selectType(sender: typeLocalButton)
                    } else if value == "flight.filters.type.international.title" {
                        selectType(sender: typeInternationalButton)
                    } else {
                        selectType(sender: typeAllButton)
                    }
                }
            case .unknown:
                continue
            }
        }
    }
    
    func setDefaultsProperties() {
        clearFields()
        setDefaultSliderValues()
        setType()
    }
    
    func clearFields() {
        toDatePicker.date = nil
        fromDatePicker.date = nil
        toPlacePicker.selectedData = nil
        fromPlacePicker.selectedData = nil
    }
    
    func setDefaultSliderValues() {
        rangeSlider.selectedMinimum = rangeSlider.minValue
        rangeSlider.selectedMaximum = rangeSlider.maxValue
    }
    
    func setPickersData() {
        let cities: [City]? = LocalRepositoryContext.sharedInstance.getAllCities()
        
        guard let data = cities else {
            return
        }
        
        let keys = data.compactMap {$0.code}
        let names = data.compactMap {$0.name}
        
        fromPlacePicker.data = (keys, names)
        toPlacePicker.data = (keys, names)
    }
    
    func setType(_ all: Bool = true, _ local: Bool = false, _ international: Bool = false) {
        typeAllButton.setSelectedWithBorder(selected: all)
        typeLocalButton.setSelectedWithBorder(selected: local)
        typeInternationalButton.setSelectedWithBorder(selected: international)
    }
    
    func selectType(sender: Any?) {
        
        guard let sender = sender as? UIButton else {
            return
        }
        
        if sender == typeAllButton {
            setType()
        } else if sender == typeLocalButton {
            setType(false, true)
        } else if sender == typeInternationalButton {
            setType(false, false, true)
        }
    }
    
    // MARK: Prepare filter items
    func createItems() -> [FlightFilterItem]? {
        var items = [FlightFilterItem]()
        
        if let item = createDateItem() {
            items.append(item)
        }
        
        if let item = createPlaceItem() {
            items.append(item)
        }
        
        if let item = createTypeItem() {
            items.append(item)
        }
        
        if let item = createTimeItem() {
            items.append(item)
        }
        
        return items.count > 0 ? items : nil
    }
    
    func createDateItem() -> FlightFilterItem? {
        let item = FlightFilterItem(type: .date)
        
        if let date = fromDatePicker.date {
            item.addValue(value: date, key: .min)
        }
        
        if let date = toDatePicker.date {
            item.addValue(value: date, key: .max)
        }
        
        return item.isEmpty() ? nil : item
    }
    
    func createPlaceItem() -> FlightFilterItem? {
        let item = FlightFilterItem(type: .place)
        
        if let text = fromPlacePicker.selectedData {
            item.addValue(value: text, key: .min)
        }

        if let text = toPlacePicker.selectedData {
            item.addValue(value: text, key: .max)
        }
        
        return item.isEmpty() ? nil : item
    }
    
    func createTypeItem() -> FlightFilterItem? {
        let item = FlightFilterItem(type: .type)
        
        if typeAllButton.isSelected {
            item.setValue(value: "all.title".localized(), key: .value)
        } else if typeLocalButton.isSelected {
            item.setValue(value: "flight.filters.type.local.title", key: .value)
        } else if typeInternationalButton.isSelected {
            item.setValue(value: "flight.filters.type.international.title", key: .value)
        }
        
        return item
    }
    
    func createTimeItem() -> FlightFilterItem? {
        let item = FlightFilterItem(type: .travelTime)
        
        item.addValue(value: rangeSlider.selectedMinimum, key: .min)
        item.addValue(value: rangeSlider.selectedMaximum, key: .max)
        
        return item
    }
    
    // MARK: Actions
    @IBAction func backButtonAction(_ sender: Any) {
        view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        view.endEditing(true)
        
        setDefaultsProperties()
    }
    
    @IBAction func applyButtonAction(_ sender: Any) {
        view.endEditing(true)
        
        let items = createItems()
        delegate?.shouldFilterWithItems(items)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func typeButtonAction(_ sender: Any) {
        selectType(sender: sender)
    }
}
