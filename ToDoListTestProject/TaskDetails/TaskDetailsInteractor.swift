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
    func recieveTask(_ task: Task)
    func didUpdateTask()
}


class TaskDetailsInteractor {
    
    weak var presenter: TaskDetailsInteractorOutputPritocol!
    var task: Task?
    let taskManager: TaskManager
    
    init(presenter: TaskDetailsInteractorOutputPritocol, task: Task?, taskManager: TaskManager) {
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
        let newTask = task
        if self.task == nil {
            taskManager.addTask(title: newTask.title, detail: newTask.description, date: newTask.date)
        } else {
            guard let task = self.task else { return }
            taskManager.updateTask(task, title: newTask.title, detail: newTask.description, date: newTask.date, isCompleted: false)
        }
        presenter.didUpdateTask()
    }
}
