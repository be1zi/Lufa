//
//  MenuFactory.swift
//  Lufa
//
//  Created by Konrad Belzowski on 11/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

class MenuFactory: NSObject {
    
    static func mainMenuItems() -> [MenuBaseItem] {
        
        return [MenuHomeItem(),
                MenuProfileItem()]
    }
}
