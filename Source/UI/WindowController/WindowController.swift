//
//  WindowController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 01/04/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class WindowController {
    
    var window: UIWindow
    
    //MARK: Constructor
    init(window: UIWindow) {
        self.window = window
    }
    
    func presentAuthorizationController() {
        
        let vc = UIStoryboard.init(name: "Authorization", bundle: nil).instantiateInitialViewController()
        
        guard let viewController = vc else {
            return
        }

        presentViewControllerAsRoot(viewController: viewController)
    }
        
    private func presentViewControllerAsRoot(viewController: UIViewController) {
        
         let rootViewController = window.rootViewController
        
        window.rootViewController = viewController
        
        if let previousRootVC = rootViewController {
            previousRootVC.dismiss(animated: false) {
                previousRootVC.view.removeFromSuperview()
            }
        }
    }
}
