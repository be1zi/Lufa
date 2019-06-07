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
    
    func addOneToManyRelationship(data: Any?, set: Set<NSManagedObject>, forEntityName name: String) -> Set<NSManagedObject> {
        return LocalRepositoryContext.sharedInstance.addOneToManyRelationship(data:data, inSet: set, forEntityName: name)
    }
    
    func addOneToOneRelationship(data: Any?, forEntityName name: String, forProperty property: NSManagedObject?) -> NSManagedObject? {
        return LocalRepositoryContext.sharedInstance.addOneToOneRelationship(data: data, forEntityName: name, forProperty: property)
    }
}
