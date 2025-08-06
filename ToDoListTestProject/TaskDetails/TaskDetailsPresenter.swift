//
//  TaskDetailsPresenter.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskDetailsPresenterProtocol: AnyObject {
    func showTask()
    func didEndEditing(title: String?, date: String, description: String?)
}

class TaskDetailsPresenter {
    
    weak var viewController: TaskDetailsViewProtocol!
    var interactor: TaskDetailsInteractorProtocol!
    var router: TaskDetailsRouterProtocol!
    
    init(viewController: TaskDetailsViewProtocol) {
        self.viewController = viewController
    }
}


extension TaskDetailsPresenter: TaskDetailsPresenterProtocol {
    
    func showTask() {
        interactor.fetchTask()

    }
    
    func didEndEditing(title: String?, date: String, description: String?) {
        guard let title = title else { return }
        let task = TaskDetailsEntity(title: title, description: description ?? "", date: date)
        interactor.updateTask(task)
    }
}

extension TaskDetailsPresenter: TaskDetailsInteractorOutputPritocol {
    func didUpdateTask() {
        viewController.didUpdateTask()
    }
    
    func recieveTask(_ task: Task) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let title = task.title ?? ""
        let description = task.details ?? ""
        let date = task.date ?? dateFormatter.string(from: Date())
        
        let task = TaskDetailsEntity(title: title, description: description, date: date)
        viewController.displayTaskDetails(task: task)
    }
}
