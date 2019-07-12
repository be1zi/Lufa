//
//  Array+Lufa.swift
//  Lufa
//
//  Created by Konrad Belzowski on 12/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import CoreData

extension Array {
    
    func unmanagedCopy() -> [NSManagedObject] {
        
        guard count > 0, let _ = first as? NSManagedObject else {
            return []
        }
        
        var content: [NSManagedObject] = []
        
        for item in self {
            if let item = item as? NSManagedObject {
                content.append(item.unmanagedCopy())
            }
        }
        
        return content
    }
}
