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
    func viewDidLoad()
    func task(atIndex indexPath: IndexPath) -> ToDos?
    func taskCompletionToggle(at task: ToDos)
    func removeTask(_ taks: ToDos)
    func searchTasks(by text: String)
    func cancelSearch()
    func routeToTaskDetails(task: ToDos?)
}

class TaskListPresenter {
    
    weak var view: TaskListViewProtocol!
    var interactor: TaskListInteractorProtocol!
    var router: TaskListRouterProtocol!
    
    private var displayedTasks: [ToDos] = []
    private var allTasks: [ToDos] = []
    private var isSearchActive = false
    
    var tasks: [ToDos] {
        return displayedTasks
    }
    
    var taskCount: Int? {
        return tasks.count
    }
    
    init(view: TaskListViewProtocol) {
        self.view = view
    }
}

extension TaskListPresenter: TaskListPresenterProtocol {
    
    func taskCompletionToggle(at task: ToDos) {
        interactor.completeTask(at: task)
    }
    
    func viewDidLoad() {
        interactor.fetchTasks()
    }
    
    func task(atIndex indexPath: IndexPath) -> ToDos? {
        return tasks.indices.contains(indexPath.row) ? tasks[indexPath.row] : nil
    }
    
    func removeTask(_ taks: ToDos) {
        interactor.removeTask(taks)
    }
    
    func searchTasks(by text: String) {
        isSearchActive = !text.isEmpty
        interactor.searchTasks(with: text)
    }
    
    func cancelSearch() {
        isSearchActive = false
        self.displayedTasks = allTasks
        interactor.cancelSearch()
    }
    
    func routeToTaskDetails(task: ToDos?) {
        router.navigateToTaskDetailsForEdit(task: task)
    }
}

extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didUpdateTasks(_ tasks: [ToDos]) {
        self.allTasks = tasks
        if isSearchActive {
            for i in 0..<displayedTasks.count {
                if let updatedTask = allTasks.first(where: { $0 == displayedTasks[i] }) {
                    displayedTasks[i] = updatedTask
                }
            }
        } else {
            self.displayedTasks = tasks
        }
        view.reloadData()
    }
    
    func didFetchTask(_ tasks: [ToDos]) {
        self.allTasks = tasks
        self.displayedTasks = tasks
        view.reloadData()
    }
    
    func didSearchTasks(_ tasks: [ToDos]) {
        self.displayedTasks = tasks
        view.reloadData()
    }
}
