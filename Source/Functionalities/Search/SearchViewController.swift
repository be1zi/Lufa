//
//  SearchViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 16/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

protocol SearchDelegate {
    
}

class SearchViewController: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var textFieldIndicator: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var data: [Any] = []
    var delegate: SearchDelegate?
    
    //MARK: - Lifecycle
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
    
    //MARK: - Appearance
    override func navigationBarTitle() -> String? {
        return "search.title".localized()
    }
    
    override func constraintToBottom() -> NSLayoutConstraint? {
        return bottomConstraint
    }
    
    //MARK: - Data
    func reloadData() {
        
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
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
