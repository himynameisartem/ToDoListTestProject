//
//  TaskListRouter.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskListRouterProtocol: AnyObject {
    func navigateToTaskDetails(for task: Task?)
}

class TaskListRouter {
    weak var viewController: TaskListViewController!
    private let taskManager: TaskManager
    
    init(viewController: TaskListViewController, taskManager: TaskManager) {
        self.viewController = viewController
        self.taskManager = taskManager
    }
}

extension TaskListRouter: TaskListRouterProtocol {
    func navigateToTaskDetails(for task: Task?) {
        let taskDetailsVC = TaskDetailsViewController()
        let configurator = TaskDetailsConfigurator()
        taskDetailsVC.delegate = viewController
        configurator.configure(viewController: taskDetailsVC, task: task, taskManager: taskManager)
        viewController?.navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
}
