//
//  TaskManager.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 04.08.2025.
//

import Foundation

class TaskManager {
    var tasks: [ToDos] = []

    func addTask(_ task: ToDos) {
        tasks.append(task)
    }
    
    func editTask(at index: Int, with newTask: ToDos) {
        guard index >= 0 && index < tasks.count else { return }
        tasks[index] = newTask
    }
    
    func completeTask(at index: Int) {
        guard index >= 0 && index < tasks.count else { return }
        tasks[index].completed.toggle()
    }
    
    func removeTask(at index: Int) {
        guard index >= 0 && index < tasks.count else { return }
        tasks.remove(at: index)
    }
    
    func loadTasksFromJSON(completion: @escaping ([ToDos]) -> Void) {
        NetworkManager.shared.fetchData { [weak self] result in
            self?.tasks = result.todos
            completion(result.todos)
        }
    }
}
