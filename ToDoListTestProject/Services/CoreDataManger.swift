//
//  CoreDataManger.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 06.08.2025.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Task")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
