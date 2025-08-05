//
//  TaskDetailsInteractor.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskDetailsInteractorProtocol: AnyObject {
    func fetchTask()
}

protocol TaskDetailsInteractorOutputPritocol: AnyObject {
    func recieveTask(_ task: ToDos)
}


class TaskDetailsInteractor {
    
    weak var presenter: TaskDetailsInteractorOutputPritocol!
    var task: ToDos?
    
    init(presenter: TaskDetailsInteractorOutputPritocol, task: ToDos?) {
        self.presenter = presenter
        self.task = task
    }
}


extension TaskDetailsInteractor: TaskDetailsInteractorProtocol {
    func fetchTask() {
        guard let task = task else { return }
        presenter.recieveTask(task)
    }
}
