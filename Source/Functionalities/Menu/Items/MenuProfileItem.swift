//
//  MenuProfileItem.swift
//  Lufa
//
//  Created by Konrad Belzowski on 11/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class MenuProfileItem: MenuBaseItem {
    
    override init() {
        super.init()
        
        self.title = "menu.item.profile.title".localized()
        self.image = UIImage(named: "menuProfile")
        self.storyboardName = "Profile"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
