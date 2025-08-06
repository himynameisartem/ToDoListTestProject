//
//  TaskListPresenter.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import Foundation

protocol TaskListPresenterProtocol: AnyObject {
    var tasks: [Task] { get }
    var taskCount: Int? { get }
    func viewDidLoad()
    func updateTask()
    func task(atIndex indexPath: IndexPath) -> Task?
    func toggleCompletion(at task: Task)
    func deleteTask(_ taks: Task)
    func shareTask(_ task: Task)
    func searchTasks(by text: String)
    func cancelSearch()
    func navigateToTaskDetails(task: Task?)
}

class TaskListPresenter {
    
    weak var view: TaskListViewProtocol!
    var interactor: TaskListInteractorProtocol!
    var router: TaskListRouterProtocol!
    
    private var displayedTasks: [Task] = []
    private var allTasks: [Task] = []
    private var isSearchActive = false
    
    var tasks: [Task] {
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
    
    func toggleCompletion(at task: Task) {
        interactor.toggleTaskCompletion(at: task)
    }
    
    func viewDidLoad() {
        interactor.fetchTasks()
    }
    
    func updateTask() {
        interactor.updateTask()
    }
    
    func task(atIndex indexPath: IndexPath) -> Task? {
        return tasks.indices.contains(indexPath.row) ? tasks[indexPath.row] : nil
    }
    
    func deleteTask(_ taks: Task) {
        interactor.removeTask(taks)
    }
    
    func shareTask(_ task: Task) {
        interactor.shareTask(task)
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
    
    func navigateToTaskDetails(task: Task?) {
        router.navigateToTaskDetails(for: task)
    }
}

extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didUpdateTasks(_ tasks: [Task]) {
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
    
    func didFetchTask(_ tasks: [Task]) {
        self.allTasks = tasks
        self.displayedTasks = tasks
        view.reloadData()
    }
    
    func didShareTask(_ task: String) {
        view.displayShareTask(task)
    }
    
    func didSearchTasks(_ tasks: [Task]) {
        self.displayedTasks = tasks
        view.reloadData()
    }
}
