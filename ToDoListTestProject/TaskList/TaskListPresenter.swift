//
//  TaskListPresenter.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskListPresenterProtocol: AnyObject {
    
}

class TaskListPresenter: TaskListPresenterProtocol {
    
    weak var view: TaskListViewProtocol!
    var interactor: TaskListInteractorProtocol!
}
