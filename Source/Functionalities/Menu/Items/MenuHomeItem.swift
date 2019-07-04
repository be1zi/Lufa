//
//  MenuHomeItem.swift
//  Lufa
//
//  Created by Konrad Belzowski on 11/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class MenuHomeItem: MenuBaseItem {
    
    override init() {
        super.init()
        
        self.title = "menu.item.home.title".localized()
        self.image = UIImage(named: "menuHome")
        self.storyboardName = "Home"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
