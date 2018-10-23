//
/*
TaskCategoryManager.swift
Created on: 10/9/18

Abstract:
 Wrapper for the CategoryManager

*/

import Cocoa

class TaskCategoryManager: NSObject {
    private static let coreDataManager = CoreDataManager.shared
    
    static func getAllTaskCategories() -> [TaskCategory] {
        var categories = [TaskCategory]()
        let fetchRequest: NSFetchRequest<TaskCategory> = TaskCategory.fetchRequest()
        do {
            categories = try coreDataManager.viewContext.fetch(fetchRequest)
        } catch {
            fatalError("Invalid preference choosen from db")
        }
        return categories
    }
    
    static func createDefaultTaskCategory() {
        guard self.getAllTaskCategories().isEmpty else {
            return
        }
        
        let taskCategory = TaskCategory()
        taskCategory.name = "Others"
        coreDataManager.saveContext()
    }
    
    static func getCategory(_ name: String) -> TaskCategory? {
        let fetchRequest: NSFetchRequest<TaskCategory> = TaskCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        do {
            return try coreDataManager.viewContext.fetch(fetchRequest).first
        } catch {
            fatalError("Invalid preference choosen from db")
        }
        return nil
    }
}
