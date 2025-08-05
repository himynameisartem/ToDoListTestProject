//
//  TaskManager.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 04.08.2025.
//

import Foundation

class TaskManager {
    var tasks: [ToDos] = []
    private var isDataLoaded = false

    func addTask(_ task: ToDos) {
        tasks.append(task)
    }
    
    func editTask(at index: Int, with newTask: ToDos) {
        guard index >= 0 && index < tasks.count else { return }
        tasks[index] = newTask
    }
    
    func completeTask(at task: ToDos) {
        if let index = tasks.firstIndex(where: { $0 == task}) {
            tasks[index].completed.toggle()
        }
    }
    
    func removeTask(at index: Int) {
        guard index >= 0 && index < tasks.count else { return }
        tasks.remove(at: index)
    }
    
    func loadTasksFromJSON(completion: @escaping ([ToDos]) -> Void) {
        guard !isDataLoaded else { completion(tasks)
            return
        }

        NetworkManager.shared.fetchData { [weak self] result in
            self?.tasks = result.todos
            completion(result.todos)
        }
    }
    
    func searchTasks(with query: String) -> [ToDos] {
        return tasks.filter { task in
            task.todo.lowercased().contains(query.lowercased())
        }
    }
}
