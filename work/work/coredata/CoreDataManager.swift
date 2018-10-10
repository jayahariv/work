//
/*
CoreDataManager.swift
Created on: 10/9/18

Abstract:
TODO: Purpose of file

*/

import Cocoa
import CoreData

class CoreDataManager: NSObject {
    
    /// PUBLIC
    static var shared: CoreDataManager {
        return instance
    }
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    /// PRIVATE
    static let instance = CoreDataManager()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "work")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
