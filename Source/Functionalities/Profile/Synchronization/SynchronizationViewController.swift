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
    
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var synchronizeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var generalCellsTypes: [SynchroType] = []
    var specificCellsTypes: [SynchroType] = []
    var allGeneralChecked: Bool = false
    var allSpecificChecked: Bool = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configure()
        loadData()
    }
    
    func configure() {
        
        tableView.register(UINib(nibName: "SynchronizationTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SynchronizationTableViewHeader")
        tableView.register(UINib(nibName: "SynchronizationTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "SynchronizationTableViewCell")
    }
    
    func loadData() {
        generalCellsTypes = SynchronizationFactory.getGeneralCellsTypesArray()
        specificCellsTypes = SynchronizationFactory.getSpecificCellsTypesArray()
    }
    
    //MARK: - Appearance
    override func navigationBarTitle() -> String? {
        return "synchronization.title".localized()
    }
    
    //MARK: - Actions
    @IBAction func synchronizeAction(_ sender: Any) {
    
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SynchronizationViewController: UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 200
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SynchronizationTableViewCell", for: indexPath) as? SynchronizationTableViewCell else {
            return UITableViewCell()
        }
        
        var title: String = ""
        var checked: Bool  = false
        
        switch indexPath.section {
        case SynchronizationSectionType.General.rawValue:
            title = SynchronizationFactory.getTitleForCell(withType: generalCellsTypes[indexPath.row])
            checked = allGeneralChecked
        case SynchronizationSectionType.Specific.rawValue:
            title = SynchronizationFactory.getTitleForCell(withType: specificCellsTypes[indexPath.row])
            checked = allSpecificChecked
        default:
            title = ""
        }
        
        cell.load(title: title, on: checked)
        return cell
    }
}

extension SynchronizationViewController: SynchronizationTableViewHeaderDelegate {

    func allChecked(type: SynchronizationSectionType) {
        
        switch type {
        case .General:
            allGeneralChecked = true
        case .Specific:
            allSpecificChecked = true
        default:
            return
        }
        
        tableView.reloadData()
    }
}
