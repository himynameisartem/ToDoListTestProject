//
//  TaskListConfigirator.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskListConfigiratorProtocol {
    func configure(viewController: TaskListViewController)
}

class TaskListConfigirator: TaskListConfigiratorProtocol {
    func configure(viewController: TaskListViewController) {
        let taskManager = TaskManager()
        let presenter = TaskListPresenter(view: viewController)
        let interactor = TaskListInteractor(presenter: presenter, taskManager: taskManager)
        let router = TaskListRouter(viewController: viewController, taskManager: taskManager)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
