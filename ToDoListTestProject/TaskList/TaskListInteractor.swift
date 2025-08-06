//
//  TaskListInteractor.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskListInteractorProtocol: AnyObject {
    var tasks: [ToDos] { get }
    func fetchTasks()
    func updateTask()
    func toggleTaskCompletion(at task: ToDos)
    func removeTask(_ task: ToDos)
    func searchTasks(with query: String)
    func cancelSearch()
    func shareTask(_ task: ToDos)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTask(_ tasks: [ToDos])
    func didUpdateTasks(_ tasks: [ToDos])
    func didSearchTasks(_ tasks: [ToDos])
    func didShareTask(_ task: String)
}

class TaskListInteractor {
    
    weak var presenter: TaskListInteractorOutputProtocol!
    private let taskManager: TaskManager
    
    init(presenter: TaskListInteractorOutputProtocol, taskManager: TaskManager) {
        self.presenter = presenter
        self.taskManager = taskManager
    }
    
}

extension TaskListInteractor: TaskListInteractorProtocol {
    func updateTask() {
        presenter.didUpdateTasks(taskManager.tasks)
    }
    
    func toggleTaskCompletion(at task: ToDos) {
        taskManager.completeTask(at: task)
        presenter.didUpdateTasks(taskManager.tasks)
    }
    
    func removeTask(_ task: ToDos) {
        taskManager.removeTask(task)
        presenter.didUpdateTasks(taskManager.tasks)
    }
    
    var tasks: [ToDos] {
        taskManager.tasks
    }
    func shareTask(_ task: ToDos) {
        let taskDescription = "Task: \(task.todo)\nDescription: \(task.description ?? "")\nDate: \(task.date ?? "")"
        presenter.didShareTask(taskDescription)
    }
    
    func fetchTasks() {
        taskManager.loadTasksFromJSON { [weak self] tasks in
            self?.presenter.didFetchTask(tasks)
        }
    }
    
    func searchTasks(with query: String){
        let filteredTasks = taskManager.searchTasks(with: query)
        presenter.didSearchTasks(filteredTasks)
    }
    
    func cancelSearch() {
        presenter.didUpdateTasks(taskManager.tasks)
    }
}
