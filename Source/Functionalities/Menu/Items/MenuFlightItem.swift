//
//  MenuFlightItem.swift
//  Lufa
//
//  Created by Konrad Belzowski on 01/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class MenuFlightItem: MenuBaseItem {
    
    override init() {
        super.init()
        
        self.title = "Flight"
        self.image = UIImage(named: "menuFlight")
        self.storyboardName = "Flight"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
