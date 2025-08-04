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
    func addTask(_ task: ToDos)
    func editTask(at index: Int, with newTask: ToDos)
    func completeTask(at index: Int)
    func removeTask(at index: Int)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTask(_ tasks: [ToDos])
    func didUpdateTasks(_ tasks: [ToDos])
}

class TaskListInteractor {
    
    weak var presenter: TaskListInteractorOutputProtocol!
    private let taskManager = TaskManager()
    
    init(presenter: TaskListInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
}

extension TaskListInteractor: TaskListInteractorProtocol {
    func addTask(_ task: ToDos) {
        taskManager.addTask(task)
    }
    
    func editTask(at index: Int, with newTask: ToDos) {
        taskManager.editTask(at: index, with: newTask)
    }
    
    func completeTask(at index: Int) {
        taskManager.completeTask(at: index)
        presenter.didUpdateTasks(tasks)
    }
    
    func removeTask(at index: Int) {
        taskManager.removeTask(at: index)
    }
    
    var tasks: [ToDos] {
        taskManager.tasks
    }
    
    func fetchTasks() {
        taskManager.loadTasksFromJSON { [weak self] tasks in
            self?.presenter.didFetchTask(tasks)
        }
    }
}
