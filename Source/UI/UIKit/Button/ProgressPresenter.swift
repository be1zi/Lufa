//
//  ProgressPresenter.swift
//  Lufa
//
//  Created by Konrad Belzowski on 02/04/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

typealias ProgressPresenterCompletion = () -> Void

class ProgressPresenter {
    
    var viewController: UIViewController
    
    init(viewVontroller: UIViewController) {
        self.viewController = viewVontroller
    }
    
    func presentProgress(withText: String?, completion: ProgressPresenterCompletion?) {
        
        DispatchQueue.main.async { [weak self] in
            
            HUD.hide()
            
            if self?.viewController.viewIfLoaded == nil {
                
                if let completion = completion {
                    completion()
                }
                
                return
            }
        
            let text = withText ?? "loading.title".localized()
            
            HUD.show(HUDContentType.labeledProgress(title: text, subtitle: nil))
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    func hideProgress() {
        DispatchQueue.main.async {
            HUD.hide()
        }
    }
}
