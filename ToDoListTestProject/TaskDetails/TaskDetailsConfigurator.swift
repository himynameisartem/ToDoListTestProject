//
//  TaskDetailsConfigurator.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskDetailsConfiguratorProtocol: AnyObject {
    func configure(viewController: TaskDetailsViewController, task: ToDos?)
}

class TaskDetailsConfigurator: TaskDetailsConfiguratorProtocol {
    func configure(viewController: TaskDetailsViewController, task: ToDos?) {
        let presenter = TaskDetailsPresenter(viewController: viewController)
        let interactor = TaskDetailsInteractor(presenter: presenter, task: task)
        let router = TaskDetailsRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
