//
//  TaskDetailsPresenter.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskDetailsPresenterProtocol: AnyObject {
    
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
    
}

extension TaskDetailsPresenter: TaskDetailsInteractorOutputPritocol {
    
}
