//
//  TaskDetailsInteractor.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskDetailsInteractorProtocol: AnyObject {
    func fetchTask()
    func updateTask(_ task: TaskDetailsEntity)
}

protocol TaskDetailsInteractorOutputPritocol: AnyObject {
    func recieveTask(_ task: ToDos)
    func didUpdateTask()
}


class TaskDetailsInteractor {
    
    weak var presenter: TaskDetailsInteractorOutputPritocol!
    var task: ToDos?
    let taskManager: TaskManager
    
    init(presenter: TaskDetailsInteractorOutputPritocol, task: ToDos?, taskManager: TaskManager) {
        self.presenter = presenter
        self.task = task
        self.taskManager = taskManager
    }
}


extension TaskDetailsInteractor: TaskDetailsInteractorProtocol {
    func fetchTask() {
        guard let task = task else { return }
        presenter.recieveTask(task)
    }
    
    func updateTask(_ task: TaskDetailsEntity) {
        let newTask = ToDos(todo: task.title, completed: false, description: task.description, date: task.date)
        if self.task == nil {
            taskManager.addTask(newTask)
        } else {
            guard let task = self.task else { return }
            taskManager.editTask(task, newTask: newTask)
        }
        presenter.didUpdateTask()
    }
}
