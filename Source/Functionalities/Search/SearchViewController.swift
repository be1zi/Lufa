//
//  SearchViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 16/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol SearchDelegate {
    func searchControllerNeedsFetchRequestForLastViewedData() -> NSFetchRequest<NSFetchRequestResult>?
    func searchControllerNeedsFetchRequestWithText(text: String) -> NSFetchRequest<NSFetchRequestResult>?
    func searchControllerNeedsName(forObject: NSManagedObject) -> String?
    func searchControllerNeedsSetAsViewed(objectKey: Any?)
    func searchControllerNeedShowDetails(forObject: NSManagedObject) -> BaseViewController?
}

enum TextFieldState {
    case focus, none
}

class SearchViewController: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var textFieldIndicator: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var delegate: SearchDelegate?
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setProperties()
        reloadData()
    }
    
    func setProperties() {
        searchTextField.text = nil
        searchTextField.placeholder = "search.placeholder".localized()
        searchTextField.becomeFirstResponder()
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
    }
    
    func setStyle(state: TextFieldState) {
        
        if state == .focus {
            textFieldIndicator.backgroundColor = UIColor.lufaCyanColor
        } else {
            textFieldIndicator.backgroundColor = UIColor.lufaGreyColor
        }
    }
    
    // MARK: Appearance
    override func navigationBarTitle() -> String? {
        return "search.title".localized()
    }
    
    override func constraintToBottom() -> NSLayoutConstraint? {
        return bottomConstraint
    }
   
    override func loadTranslations() {
        cancelButton.title = "cancel.title".localized()
        clearButton.title = "clear.title".localized()
    }
    
    // MARK: Data
    func reloadData() {
        guard let delegate = delegate else {
            return
        }
        
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
        
        if let typedText = searchTextField.text, typedText.count > 0 {
            fetchRequest = delegate.searchControllerNeedsFetchRequestWithText(text: typedText)
        } else {
            fetchRequest = delegate.searchControllerNeedsFetchRequestForLastViewedData()
        }
        
        if let request = fetchRequest {
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: LocalRepositoryContext.context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
            fetchedResultsController?.delegate = self
            ((try? fetchedResultsController?.performFetch()) as ()??)
        }
        
        tableView.reloadData()
    }
    
    //MAKR: - Actions
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        searchTextField.text = nil
        
        reloadData()
    }
    
    @IBAction func textFieldValueChanged(_ sender: Any) {
        reloadData()
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let object = fetchedResultsController?.object(at: indexPath) as? NSManagedObject else {
            return
        }
        
        delegate?.searchControllerNeedsSetAsViewed(objectKey: fetchedResultsController?.object(at: indexPath))
        
        if let vc = delegate?.searchControllerNeedShowDetails(forObject: object.unmanagedCopy()) {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let object = fetchedResultsController?.object(at: indexPath) as? NSManagedObject, let delegate = delegate else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell
        let name = delegate.searchControllerNeedsName(forObject: object.unmanagedCopy()) ?? ""
        let typedText = searchTextField.text ?? ""
        let type: SearchImageType = typedText.count > 0 ? .search : .clock
        
        if let cellUnwrapped = cell {
            cellUnwrapped.load(withName: name, typedText: typedText, imageType: type)
           
            return cellUnwrapped
        }
        
        return UITableViewCell()
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setStyle(state: .focus)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        setStyle(state: .none)
    }
}

extension SearchViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        guard let index = indexPath else {
            return
        }
        
        let newIndex = newIndexPath ?? IndexPath(row: 0, section: 0)
        
        switch type {
        case .insert:
            tableView.insertRows(at: [index], with: .fade)
        case .delete:
            tableView.deleteRows(at: [index], with: .fade)
        case .move:
            tableView.deleteRows(at: [index], with: .fade)
            tableView.insertRows(at: [newIndex], with: .fade)
        case .update:
            tableView.reloadRows(at: [index], with: .fade)
        @unknown default:
            return
        }
    }
}
