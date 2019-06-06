//
//  LocalRepositoryContext.swift
//  Lufa
//
//  Created by Konrad Belzowski on 28/05/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import CoreData

class LocalRepositoryContext {
    
    static let sharedInstance = LocalRepositoryContext.init()
    
    static var context: NSManagedObjectContext {
        return LocalRepositoryContext.sharedInstance.persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Lufa")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MAKR: - Save data
    func parseAndSave(data: [String: Any], name: String) {
        parseAndSave(data: [data], name: name)
    }
    
    func parseAndSave(data: [[String: Any]], name: String) {
        
        let context = LocalRepositoryContext.context
        
        var updated = 0
        var deleted = 0
        var added = 0
    
        var newDataKeys: [String] = []
        var oldDataKeys: [String] = []
        var dataKeysToUpdate: [String] = []
        var dataKeysToDelete: [String] = []
        
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: context) else {
            return
        }
        
        let object = NSManagedObject(entity: entity, insertInto: nil)
        
        guard let primaryKey = object.primaryKey() else {
            return
        }
        
        //JSON objects keys
        for singleObject in data {
            if let key = singleObject[primaryKey] as? String {
                newDataKeys.append(key)
            }
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let result = self.executeFetch(fetchRequest: request)
        
        //Keys in database
        for singleResult in result {
            if let key = singleResult.value(forKey: primaryKey) as? String {
                oldDataKeys.append(key)
            }
        }
        
        for key in oldDataKeys {
            if !newDataKeys.contains(key) {
                dataKeysToDelete.append(key)
            } else {
                dataKeysToUpdate.append(key)
            }
        }
        
        for record in result {
            
            if let key: String = record.value(forKey: primaryKey) as? String {
                if dataKeysToUpdate.contains(key) {
                    record.serialize(data: data.first(where: {$0[primaryKey] as! String == key})!)
                    updated += 1
                } else if dataKeysToDelete.contains(key) {
                    context.delete(record)
                    deleted += 1
                }
            }
        }
        
        for singleData in data {
            
            if let key: String = singleData[primaryKey] as? String {
                if !dataKeysToUpdate.contains(key) {
                    if let entity = NSEntityDescription.entity(forEntityName: name, in: context) {
                        let object = NSManagedObject(entity: entity, insertInto: context)
                        
                        object.serialize(data: singleData)
                        added += 1
                    }
                }
            }
        }
        
        do {
            try context.save()
            print("Data saved successfully to \(name): added \(added), updated \(updated), deleted \(deleted)")
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }
    
    func addAttribute(data: [[String: Any]], name: String) -> NSSet {
        
        let context = LocalRepositoryContext.context
        let set: NSSet = []
        
        
        
//        var updated = 0
//        var added = 0
//
//        var newDataKeys: [String] = []
//        var oldDataKeys: [String] = []
//        var dataKeysToUpdate: [String] = []
//
//        guard let entity = NSEntityDescription.entity(forEntityName: name, in: context) else {
//            return set
//        }
//
//        let object = NSManagedObject(entity: entity, insertInto: nil)
//
//        guard let primaryKey = object.primaryKey() else {
//            return set
//        }
//
//        //Data keys
//        for singleObject in data {
//            if let key = singleObject[primaryKey] as? String {
//                newDataKeys.append(key)
//            }
//        }
//
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
//        let result = self.executeFetch(fetchRequest: request)
//
//        //Keys in database
//        for singleResult in result {
//            if let key = singleResult.value(forKey: primaryKey) as? String {
//                oldDataKeys.append(key)
//            }
//        }
//
//        for key in oldDataKeys {
//            if newDataKeys.contains(key) {
//                dataKeysToUpdate.append(key)
//            }
//        }
//
//        for record in result {
//
//            if let key: String = record.value(forKey: primaryKey) as? String {
//                if dataKeysToUpdate.contains(key) {
//                    record.serialize(data: data.first(where: {$0[primaryKey] as! String == key})!)
//                    updated += 1
//                }
//            }
//        }
//
//        for singleData in data {
//            if let key: String = singleData[primaryKey] as? String {
//                if !dataKeysToUpdate.contains(key) {
//                    if let entity = NSEntityDescription.entity(forEntityName: name, in: context) {
//                        let object = NSManagedObject(entity: entity, insertInto: context)
//
//                        object.serialize(data: singleData)
//                        set.adding(object)
//                        added += 1
//                    }
//                }
//            }
//        }
//
//        print("Data saved to \(name): added \(added), updated \(updated)")
        
        return set
    }
    
    //MARK: - Fetch
    func executeFetch(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject] {
        
        var result: [NSManagedObject]? = []
        
        do {
            result = try LocalRepositoryContext.context.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            print("Fetch error: \(error), \(error.localizedDescription)")
        }
        
        if let result = result {
            return result
        } else {
            return []
        }
    }
    
    //MARK: - Delete Data
    func clearDataBase() {
        
        let context = LocalRepositoryContext.context
        
        let entityNames = LocalRepositoryContext.sharedInstance.persistentContainer.managedObjectModel.entities.map(
        { (entity) -> String in
            return entity.name ?? ""
        })
        
        for entity in entityNames {
            
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print("Error clear core data: \(error), \(error.localizedDescription)")
            }
        }
    }
}
