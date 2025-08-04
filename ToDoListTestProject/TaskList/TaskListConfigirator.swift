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
        let presenter = TaskListPresenter(view: viewController)
        let interactor = TaskListInteractor(presenter: presenter)
        let router = TaskListRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
