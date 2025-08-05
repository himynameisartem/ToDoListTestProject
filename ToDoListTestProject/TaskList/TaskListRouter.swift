//
//  TaskListRouter.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskListRouterProtocol: AnyObject {
    func navigateToTaskDetailsForEdit(task: ToDos?)
    func navigateToTaskDetailsForAddTask()
}

class TaskListRouter {
    weak var viewController: TaskListViewController!
    
    init(viewController: TaskListViewController) {
        self.viewController = viewController
    }
}

extension TaskListRouter: TaskListRouterProtocol {
    
    func navigateToTaskDetailsForAddTask() {
        let taskDetailsVC = TaskDetailsViewController()
        let configurator = TaskDetailsConfigurator()
        configurator.configure(viewController: taskDetailsVC, task: nil)
        viewController?.navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
    
    func navigateToTaskDetailsForEdit(task: ToDos?) {
        let taskDetailsVC = TaskDetailsViewController()
        let configurator = TaskDetailsConfigurator()
        configurator.configure(viewController: taskDetailsVC, task: task)
        viewController?.navigationController?.pushViewController(taskDetailsVC, animated: true)
    }
}
