//
//  TaskDetailsPresenter.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskDetailsPresenterProtocol: AnyObject {
    func showTask()
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
}

extension TaskDetailsPresenter: TaskDetailsInteractorOutputPritocol {
    func recieveTask(_ task: ToDos) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let title = task.todo
        let description = task.description ?? ""
        let date = task.date ?? dateFormatter.string(from: Date())
        
        let task = TaskDetailsEntity(title: title, description: description, date: date)
        viewController.displayTaskDetails(task: task)
    }
}
