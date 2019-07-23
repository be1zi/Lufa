//
//  SynchronizationViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 09/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

enum SynchronizationSectionType: Int {
    case General
    case Specific
    case All
}

class SynchronizationViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var synchronizeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var generalCellsTypes: [SynchroType] = []
    var specificCellsTypes: [SynchroType] = []
    var checkedGeneralTypes: [SynchroType] = []
    var checkedSpecificTypes: [SynchroType] = []
    var allGeneralChecked: Bool = false
    var allSpecificChecked: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configure()
        loadData()
    }
    
    func configure() {
        
        tableView.register(UINib(nibName: "SynchronizationTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SynchronizationTableViewHeader")
        tableView.register(UINib(nibName: "SynchronizationTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "SynchronizationTableViewCell")
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Data
    func loadData() {
        generalCellsTypes = SynchronizationFactory.getGeneralCellsTypesArray()
        specificCellsTypes = SynchronizationFactory.getSpecificCellsTypesArray()
    }
    
    func prepareToSynchronize() -> [SynchroType] {
        
        var arr: [SynchroType] = []
        
        arr.append(contentsOf: checkedGeneralTypes)
        arr.append(contentsOf: checkedSpecificTypes)
        
        return arr
    }
    
    // MARK: - Appearance
    override func navigationBarTitle() -> String? {
        return "synchronization.title".localized()
    }
    
    override func loadTranslations() {
        cancelButton.setTitle("cancel.title".localized(), for: .normal)
        synchronizeButton.setTitle("synchronization.synchronize.button.title".localized(), for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func synchronizeAction(_ sender: Any) {
    
        let data = prepareToSynchronize()
        
        guard data.count > 0 else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        progressPresenter?.presentProgress(withText: "synchronization.synchronize.title".localized(), completion: {
            
            CustomeCompoundSynchroManager.sharedInstance.loadWithManagers(types: data)
            CustomeCompoundSynchroManager.sharedInstance.synchronizeWithCompletion(completion: { _, _ in
                self.progressPresenter?.hideProgress()
                self.dismiss(animated: true, completion: nil)
            }, forced: true)
        })
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SynchronizationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SynchronizationTableViewHeader") as? SynchronizationTableViewHeader else {
            return nil
        }
        
        var title: String = ""
        var type: SynchronizationSectionType = .All
        
        switch section {
        case SynchronizationSectionType.General.rawValue:
            title = SynchronizationFactory.getTitleForHeader(withType: .General)
            type = SynchronizationSectionType.General
        case SynchronizationSectionType.Specific.rawValue:
            title = SynchronizationFactory.getTitleForHeader(withType: .Specific)
            type = SynchronizationSectionType.Specific
        default:
            title = ""
        }
        
        header.load(title: title, withDelegate: self, type: type)
        
        return header
    }
}

extension SynchronizationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SynchronizationSectionType.All.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SynchronizationSectionType.General.rawValue:
            return generalCellsTypes.count
        case SynchronizationSectionType.Specific.rawValue:
            return specificCellsTypes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SynchronizationTableViewCell", for: indexPath) as? SynchronizationTableViewCell else {
            return UITableViewCell()
        }
        
        var title: String = ""
        var checked: Bool  = false
        var section: SynchronizationSectionType = .All
        var synchro: SynchroType = .All
        
        switch indexPath.section {
        case SynchronizationSectionType.General.rawValue:
            checked = allGeneralChecked
            section = .General
            synchro = generalCellsTypes[indexPath.row]
            title = SynchronizationFactory.getTitleForCell(withType: synchro)
        case SynchronizationSectionType.Specific.rawValue:
            checked = allSpecificChecked
            section = .Specific
            synchro = specificCellsTypes[indexPath.row]
            title = SynchronizationFactory.getTitleForCell(withType: synchro)
        default:
            title = ""
        }
        
        cell.load(title: title, on: checked, withDelegate: self, section: section, synchro: synchro)
        return cell
    }
}

extension SynchronizationViewController: SynchronizationDelegate {
    
    func allCheckboxChangeState(newState: Bool, type: SynchronizationSectionType) {
        
        switch type {
        case .General:
            allGeneralChecked = newState
            
            if newState == true {
                checkedGeneralTypes = generalCellsTypes
            } else {
                checkedGeneralTypes = []
            }
        case .Specific:
            allSpecificChecked = newState
            
            if newState == true {
                checkedSpecificTypes = specificCellsTypes
            } else {
                checkedSpecificTypes = []
            }
        default:
            return
        }
        
        tableView.reloadData()
    }
    
    func checkboxChangeState(newState: Bool, section: SynchronizationSectionType, type: SynchroType) {
        
        switch section {
        case .General:
            if newState == true {
                if !checkedGeneralTypes.contains(type) {
                    checkedGeneralTypes.append(type)
                }
            } else {
                if checkedGeneralTypes.contains(type),
                    let index = checkedGeneralTypes.firstIndex(of: type) {
                    checkedGeneralTypes.remove(at: index)
                }
            }
        case .Specific:
            if newState == true {
                if !checkedSpecificTypes.contains(type) {
                    checkedSpecificTypes.append(type)
                }
            } else {
                if checkedSpecificTypes.contains(type),
                    let index = checkedSpecificTypes.firstIndex(of: type) {
                    checkedSpecificTypes.remove(at: index)
                }
            }
        default:
            return
        }
    }
}
