//
//  TaskListPresenter.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskListPresenterProtocol: AnyObject {
    var tasks: [ToDos] { get }
    var taskCount: Int? { get }
    func task(atIndex indexPath: IndexPath) -> ToDos?
    func taskCompletionToggle(at index: Int)
    func viewDidLoad()
}

class TaskListPresenter {
    
    weak var view: TaskListViewProtocol!
    var interactor: TaskListInteractorProtocol!
    var router: TaskListRouterProtocol!
    
    var tasks: [ToDos] = []
    var taskCount: Int? {
        return tasks.count
    }
    
    init(view: TaskListViewProtocol) {
        self.view = view
    }
}

extension TaskListPresenter: TaskListPresenterProtocol {
    
    func taskCompletionToggle(at index: Int) {
        interactor.completeTask(at: index)
    }
    
    func viewDidLoad() {
        interactor.fetchTasks()
    }
    
    func task(atIndex indexPath: IndexPath) -> ToDos? {
        if tasks.indices.contains(indexPath.row) {
            return tasks[indexPath.row]
        } else {
            return nil
        }
    }
}

extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didUpdateTasks(_ tasks: [ToDos]) {
        self.tasks = tasks
        view.reloadData()
    }
    
    func didFetchTask(_ tasks: [ToDos]) {
        self.tasks = tasks
        view.reloadData()
    }
}
