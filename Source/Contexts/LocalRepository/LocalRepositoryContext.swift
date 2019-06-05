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
        
        let context = LocalRepositoryContext.context
        
        if let entity = NSEntityDescription.entity(forEntityName: name, in: context) {
            let object = NSManagedObject(entity: entity, insertInto: context)

            object.serialize(data: data)
            
            do {
                try context.save()
                print("Data saved successfully")
            } catch {
                print("Save error: \(error.localizedDescription)")
            }
        }
    }
    
    func parseAndSave(data: [[String: Any]], name: String) {
        
        let context = LocalRepositoryContext.context
        
        for singleData in data {
        
            if let entity = NSEntityDescription.entity(forEntityName: name, in: context) {
                let object = NSManagedObject(entity: entity, insertInto: context)
                
                object.serialize(data: singleData)
            }
        }
        
        do {
            try context.save()
            print("Data saved successfully")
        } catch {
            print("Save error: \(error.localizedDescription)")
        }
    }
    
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
}
