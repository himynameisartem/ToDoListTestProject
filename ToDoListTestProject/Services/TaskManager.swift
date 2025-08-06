//
//  TaskManager.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 04.08.2025.
//

import UIKit
import CoreData

class TaskManager {
    
    static let shared = TaskManager()
    private let context = CoreDataStack.shared.context
    
    private(set) var tasks: [Task] = []
    
    
    
    func fetchTasks(completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                self.tasks = try self.context.fetch(request)
            } catch {
                print(error.localizedDescription)
                self.tasks = []
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func addTask(title: String, detail: String, date: String, completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let task = Task(context: self.context)
            task.title = title
            task.details = detail
            task.date = date
            task.isCompleted = false
            task.createdAt = Date()
            
            CoreDataStack.shared.saveContext()
            
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                self.tasks = try self.context.fetch(request)
            } catch {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func updateTask(_ task: Task, title: String, detail: String, date: String, isCompleted: Bool, completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            task.title = title
            task.details = detail
            task.date = date
            task.isCompleted = isCompleted
            
            CoreDataStack.shared.saveContext()
            
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                self.tasks = try self.context.fetch(request)
            } catch {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func completeToggle(_ task: Task, completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            task.isCompleted.toggle()
            CoreDataStack.shared.saveContext()
            
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                self.tasks = try self.context.fetch(request)
            } catch {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
        func deleteTask(_ task: Task) {
            context.delete(task)
            CoreDataStack.shared.saveContext()
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                self.tasks = try self.context.fetch(request)
            } catch {
                print(error.localizedDescription)
            }
        }
    
    func searchTasks(by text: String, completion: @escaping ([Task]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd]%@", text)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                let result = try self.context.fetch(fetchRequest)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func performInitialLoadIfNeeded(completion: @escaping () -> Void) {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: "hasLaunchedBefore") else {
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        NetworkManager.shared.fetchData { [weak self] todosList in
            guard let self = self else { return }
            
            DispatchQueue.global().async {
                for todo in todosList.todos.reversed() {
                    let task = Task(context: self.context)
                    task.title = todo.todo
                    task.details = todo.description
                    task.date = todo.date
                    task.isCompleted = todo.completed
                    task.createdAt = Date()
                }
                
                CoreDataStack.shared.saveContext()
                defaults.set(true, forKey: "hasLaunchedBefore")
                let request: NSFetchRequest<Task> = Task.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
                
                do {
                    self.tasks = try self.context.fetch(request)
                } catch {
                    print(error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}
