//
//  TaskDetailsInteractor.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskDetailsInteractorProtocol: AnyObject {
    
}

protocol TaskDetailsInteractorOutputPritocol: AnyObject {
    
}


class TaskDetailsInteractor {
    
    weak var presenter: TaskDetailsInteractorOutputPritocol!
    
    init(presenter: TaskDetailsInteractorOutputPritocol) {
        self.presenter = presenter
    }
}


extension TaskDetailsInteractor: TaskDetailsInteractorProtocol {
    
}
