//
//  TaskListRouter.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskListRouterProtocol: AnyObject {
    
}

class TaskListRouter: TaskListRouterProtocol {
    weak var viewController: TaskListViewController!
    
    init(viewController: TaskListViewController) {
        self.viewController = viewController
    }
}
