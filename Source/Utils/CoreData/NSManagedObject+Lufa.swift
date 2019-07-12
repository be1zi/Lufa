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
    
    func addDateProperty(date: Any?) -> Date? {
        
        if let date = date as? String {
            if let result = DateFormatter.stringToDate(date: date) {
                return result
            } else if let result = DateFormatter.stringToDateTime(date: date) {
                return result
            }
        } else if let date = date as? Date {
            return date
        }
        
        return nil
    }
    
    func unmanagedCopy() -> NSManagedObject {
        
        let copy = NSManagedObject(entity: self.entity, insertInto: nil)
        
        let attributesKeys = self.entity.attributesByName.keys
        
        var keys: [String] = []
        
        for key in attributesKeys {
            keys.append(key)
        }
        
        let dict = self.dictionaryWithValues(forKeys: keys)
        
        copy.serialize(data: dict)
        
        return copy
    }
}
