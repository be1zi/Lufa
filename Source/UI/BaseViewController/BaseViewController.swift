//
//  BaseViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 22/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: Variables
    
    lazy var progressPresenter: ProgressPresenter? = {
        return ProgressPresenter.init(viewVontroller: self)
    }()
    
    private var keyboardHeight: CGFloat = 0
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        synchronizeData()
        loadConfigurations()
        loadTranslations()
        registerForKeyboardEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        synchronizeData()
        loadConfigurations()
    }
    
    deinit {
        unregisterFromKeyboardEvents()
    }
    
    // MARK: Properties
    
    func loadConfigurations() {
        
        let navigationBarHidden = shouldHideNavigationBar()
        self.navigationController?.setNavigationBarHidden(navigationBarHidden, animated: true)
        
        let backButton = UIBarButtonItem()
        navigationItem.backBarButtonItem = backButton
        
        self.title = navigationBarTitle()
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lufaGreenColor]
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationController?.navigationBar.tintColor = UIColor.lufaGreenColor
        
        navigationController?.navigationItem.setHidesBackButton(shouldHideBackButton(), animated: false)
    }
    
    func loadTranslations() {
        
    }
    
    func navigationBarTitle() -> String? {
        return nil
    }
    
    func shouldHideNavigationBar() -> Bool {
        return false
    }
    
    func shouldHideBackButton() -> Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func constraintToBottom() -> NSLayoutConstraint? {
        return nil
    }
    
    // MARK: Data
    
    func synchronizeData() {
        
    }
    
    // MARK: Keyboard
    
    private func registerForKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppearNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppearNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappearNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisappearNotification(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(keyboardHide))
        tap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tap)
    }
    
    private func unregisterFromKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let rect = frame.cgRectValue
            
            return rect.height
        }
        
        return 0
    }
    
    @objc private func keyboardWillAppearNotification(_ notification: Notification) {
        
        let height = self.keyboardHeight(notification)
        
        if keyboardHeight == 0 {
            keyboardWillAppear(height)
        }
    }
    
    @objc private func keyboardDidAppearNotification(_ notification: Notification) {
        
        let height = self.keyboardHeight(notification)
        
        if keyboardHeight > 0 {
            keyboardDidChangeFrame(from: keyboardHeight, to: height)
        } else {
            keyboardDidAppear(height)
        }
        
        keyboardHeight = height
    }
    
    @objc private func keyboardWillDisappearNotification(_ notification: Notification) {
        
        let height = self.keyboardHeight(notification)
        self.keyboardWillDisappear(height)
    }
    
    @objc private func keyboardDidDisappearNotification(_ notification: Notification) {
        
        let height = self.keyboardHeight(notification)
        self.keyboardDidDisappear(height)
        
        keyboardHeight = 0
    }
    
    func keyboardWillAppear(_ height: CGFloat) {
        
        guard let bottomConstraint = constraintToBottom() else {
            return
        }
        
        bottomConstraint.constant = height - self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardDidAppear(_ height: CGFloat) {
        
    }
    
    func keyboardWillDisappear(_ height: CGFloat) {
        
        guard let bottomConstraint = constraintToBottom() else {
            return
        }
        
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        keyboardHeight = 0
    }
    
    func keyboardDidDisappear(_ height: CGFloat) {
        
    }
    
    private func keyboardDidChangeFrame(from: CGFloat, to: CGFloat) {
        
        guard let bottomConstraint = constraintToBottom() else {
            return
        }
        
        bottomConstraint.constant = to - self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardHide() {
        self.view.endEditing(true)
    }
}
