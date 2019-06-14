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
        
        let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateInitialViewController()
        let profileVC = UIStoryboard.init(name: "Profile", bundle: nil).instantiateInitialViewController()
        let flightVC = UIStoryboard.init(name: "Flight", bundle: nil).instantiateInitialViewController()
        
        if let viewController = vc {
            viewController.tabBarItem = UITabBarItem(title: "Home", image: nil, tag: 1)
            self.viewControllers = [viewController]
        }
        
        if let flight = flightVC {
            flight.tabBarItem = UITabBarItem(title: "Flight", image: nil, tag: 3)
            self.viewControllers?.append(flight)
        }
        
        if let profile = profileVC {
            profileVC?.tabBarItem = UITabBarItem(title: "Profile", image: nil, tag: 2)
            self.viewControllers?.append(profile)
        }
    }
}