//
//  TaskDetailsRouter.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskDetailsRouterProtocol: AnyObject {
    
}


class TaskDetailsRouter: TaskDetailsRouterProtocol {
    weak var viewController: TaskDetailsViewController!
    
    init(viewController: TaskDetailsViewController) {
        self.viewController = viewController
    }
}
