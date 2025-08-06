//
//  TaskListInteractor.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskListInteractorProtocol: AnyObject {
    var tasks: [Task] { get }
    func fetchTasks()
    func updateTask()
    func toggleTaskCompletion(at task: Task)
    func removeTask(_ task: Task)
    func searchTasks(with query: String)
    func cancelSearch()
    func shareTask(_ task: Task)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTask(_ tasks: [Task])
    func didUpdateTasks(_ tasks: [Task])
    func didSearchTasks(_ tasks: [Task])
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
        taskManager.fetchTasks()
        presenter.didUpdateTasks(taskManager.tasks)
    }
    
    func toggleTaskCompletion(at task: Task) {
        taskManager.completeToggle(task)
        presenter.didUpdateTasks(taskManager.tasks)
    }
    
    func removeTask(_ task: Task) {
        taskManager.deleteTask(task)
        presenter.didUpdateTasks(taskManager.tasks)
    }
    
    var tasks: [Task] {
        taskManager.tasks
    }
    func shareTask(_ task: Task) {
        let taskDescription = "Task: \(task.title ?? "")\nDescription: \(task.details ?? "")\nDate: \(task.date ?? "")"
        presenter.didShareTask(taskDescription)
    }
    
    func fetchTasks() {
        taskManager.fetchTasks()
        DispatchQueue.main.async {
            self.presenter.didFetchTask(self.tasks)
        }
    }
    
    func searchTasks(with query: String){
        let filteredTasks = taskManager.searchTasks(by: query)
        presenter.didSearchTasks(filteredTasks)
    }
    
    func cancelSearch() {
        presenter.didUpdateTasks(taskManager.tasks)
    }
}
