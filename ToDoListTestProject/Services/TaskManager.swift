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
    
    func fetchTasks()  {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasks = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return tasks = []
        }
    }
    
    func addTask(title: String, detail: String, date: String) {
        let task = Task(context: context)
        task.title = title
        task.details = detail
        task.date = date
        task.isCompleted = false
        CoreDataStack.shared.saveContext()
        fetchTasks()
    }
    
    func updateTask(_ task: Task, title: String, detail: String, date: String, isCompleted: Bool) {
        task.title = title
        task.details = detail
        task.date = date
        task.isCompleted = isCompleted
        CoreDataStack.shared.saveContext()
        fetchTasks()
    }
    
    func completeToggle(_ task: Task) {
        task.isCompleted.toggle()
        CoreDataStack.shared.saveContext()
        fetchTasks()
    }
    
    func searchTasks(by text: String) -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR detail CONTAINS[cd] %@", text, text)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteTask(_ task: Task) {
        context.delete(task)
        CoreDataStack.shared.saveContext()
        fetchTasks()
    }
    
    func preloadDataIfNeeded() {

    }
}

//class TaskManager {
//    var tasks: [ToDos] = []
//    private var isDataLoaded = false
//
//    func addTask(_ task: ToDos) {
//        tasks.insert(task, at: 0)
//    }
//
//    func editTask(_ task: ToDos, newTask: ToDos) {
//        if let index = tasks.firstIndex(where: { $0 == task}) {
//            tasks[index] = newTask
//        }
//    }
//
//    func completeTask(at task: ToDos) {
//        if let index = tasks.firstIndex(where: { $0 == task}) {
//            tasks[index].completed.toggle()
//        }
//    }
//
//    func removeTask(_ task: ToDos) {
//        if let index = tasks.firstIndex(where: { $0 == task}) {
//            tasks.remove(at: index)
//        }
//    }
//
//    func loadTasksFromJSON(completion: @escaping ([ToDos]) -> Void) {
//        guard !isDataLoaded else { completion(tasks)
//            return
//        }
//
//        NetworkManager.shared.fetchData { [weak self] result in
//            self?.tasks = result.todos
//            completion(result.todos)
//        }
//    }
//
//    func searchTasks(with query: String) -> [ToDos] {
//        return tasks.filter { task in
//            task.todo.lowercased().contains(query.lowercased())
//        }
//    }
//}
