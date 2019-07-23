//
//  MenuTapBarController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 11/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import UIKit

class MenuTapBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        setStyle()
    }
    
    func loadItems() {
        let items = MenuFactory.mainMenuItems()
        
        for item in items {
            
            if item.storyboardName.count < 1 {
                continue
            }
            
            let vc = UIStoryboard.init(name: item.storyboardName, bundle: nil).instantiateInitialViewController()
            
            if let controller = vc {
                controller.tabBarItem = item
                
                if self.viewControllers != nil {
                    self.viewControllers?.append(controller)
                } else {
                    self.viewControllers = [controller]
                }
            }
        }
    }
    
    func setStyle() {
        tabBar.tintColor = UIColor.lufaGreenColor
        tabBar.barStyle = UIBarStyle.default
        tabBar.isTranslucent = false
    }
}
