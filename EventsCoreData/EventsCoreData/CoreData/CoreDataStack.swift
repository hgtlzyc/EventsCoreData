//
//  CoreDataStack.swift
//  EventsCoreData
//
//  Created by lijia xu on 7/30/21.
//

import CoreData

enum CoreDataStack {
    
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EventsCoreData")
        container.loadPersistentStores { _, err in
            if let err = err {
                fatalError("\(err)")
            }
        }
        return container
    }()
    
    static let context: NSManagedObjectContext = {
        container.viewContext
    }()
    
    static func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Error saving Context \(error)")
        }
    }
    
}
