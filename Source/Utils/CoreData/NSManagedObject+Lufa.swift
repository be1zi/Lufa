//
//  NSManagedObject+Lufa.swift
//  Lufa
//
//  Created by Konrad Belzowski on 03/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import CoreData

extension NSManagedObject {
    
    @objc func serialize(data: [String: Any]) {
        
    }
    
    @objc func primaryKey() -> String? {
        return nil
    }
    
    func addRelationship(data: [[String: Any]],
                         forProperty: String,
                         entityName: String,
                         rootEntityName: String,
                         rootPrimeryKeyValue: String) -> NSSet {
        
        return LocalRepositoryContext.sharedInstance.addAttribute(data: data, forProperty: forProperty , entityName: entityName, rootEntityName: rootEntityName, rootPrimaryKeyValue: rootPrimeryKeyValue )
    }
}
