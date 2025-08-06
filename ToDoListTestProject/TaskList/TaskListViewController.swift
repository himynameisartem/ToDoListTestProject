//
//  TaskListViewController.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import UIKit

protocol TaskListViewProtocol: AnyObject {
    func reloadData()
    func displayShareTask(_ taskDescription: String)
}

class TaskListViewController: UIViewController {
    
    var presenter: TaskListPresenterProtocol!
    private let configurator: TaskListConfigiratorProtocol = TaskListConfigirator()
    
    var taskListTableView: UITableView!
    var bottomBarView: UIView!
    var bottomContainerView: UIView!
    var tasksCountLabel: UILabel!
    var addTaskButton: UIButton!
    let searchController = UISearchController(searchResultsController: nil)
    private var sharedActivitiIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(viewController: self)
        presenter.viewDidLoad()
        setupNavigationBar()
        setupSearchController()
        setupBottomBarView()
        setupTaskListTableView()
        setupActivitiIndicator()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(bottomBarView)
        bottomBarView.addSubview(tasksCountLabel)
        bottomBarView.addSubview(addTaskButton)
        view.addSubview(taskListTableView)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Tasks"
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .yellow
    }
    
    private func setupSearchController() {

        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search tasks...",
            attributes: [
                .foregroundColor: UIColor.lightGray,
            ]
        )
        searchController.searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .lightGray
        searchController.searchBar.searchTextField.backgroundColor = .darkGray
        searchController.searchBar.delegate = self
        
        DispatchQueue.main.async {
            if let textField = self.searchController.searchBar.value(forKey: "searchField") as? UITextField {
                textField.textColor = .white
                textField.tintColor = .white
            }
        }
    }
    
    private func setupBottomBarView() {
        bottomContainerView = UIView()
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.backgroundColor = .darkGray
        
        bottomBarView = UIView()
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarView.backgroundColor = .none
        
        tasksCountLabel = UILabel()
        tasksCountLabel.font = .systemFont(ofSize: 13)
        tasksCountLabel.textColor = .white
        tasksCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addTaskButton = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let image = UIImage(systemName: "square.and.pencil", withConfiguration: config)
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.setImage(image, for: .normal)
        addTaskButton.tintColor = .yellow
        addTaskButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    private func setupTaskListTableView() {
        taskListTableView = UITableView()
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        taskListTableView.translatesAutoresizingMaskIntoConstraints = false
        taskListTableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: "TaskListTableViewCell")
        taskListTableView.backgroundColor = .black
        taskListTableView.separatorColor = .darkGray
    }
    
    private func setupActivitiIndicator() {
        sharedActivitiIndicator = UIActivityIndicatorView(frame: view.bounds)
        view.addSubview(sharedActivitiIndicator)
        sharedActivitiIndicator.center = view.center
        sharedActivitiIndicator.style = .large
        sharedActivitiIndicator.hidesWhenStopped = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 49),
            
            bottomContainerView.topAnchor.constraint(equalTo: bottomBarView.topAnchor),
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tasksCountLabel.centerXAnchor.constraint(equalTo: bottomBarView.centerXAnchor),
            tasksCountLabel.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            
            addTaskButton.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            addTaskButton.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -20),
            addTaskButton.heightAnchor.constraint(equalToConstant: 30),
            addTaskButton.widthAnchor.constraint(equalToConstant: 30),
            
            taskListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskListTableView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor)
        ])
    }
    
    @objc private func didTapAddButton(_ sender: UIButton) {
        presenter.navigateToTaskDetails(task: nil)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.taskCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell", for: indexPath) as! TaskListTableViewCell
        
        guard let task = presenter.task(atIndex: indexPath) else { return cell}
        cell.configure(task: task)
        cell.checkmarkButtonAction = { [weak self] in
            self?.presenter.toggleCompletion(at: task)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        106
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let task = presenter.task(atIndex: indexPath) else { return nil }
        
        let configuration = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { action in
            let addTask = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { action in
                self.presenter.navigateToTaskDetails(task: task)
            }
            let editTask = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
                self.presenter.shareTask(task)
            }
            let deleteTask = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                self.presenter.deleteTask(task)
            }
            return UIMenu(title: "", children: [addTask, editTask, deleteTask])
        }
        return configuration
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return  nil }
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskListTableViewCell else { return nil }
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .darkGray
        return UITargetedPreview(view: cell.containerView, parameters: parameters)
    }
}

//MARK: - UISearchBarDelegate

extension TaskListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            presenter.searchTasks(by: searchText)
        } else {
            presenter.cancelSearch()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        presenter.cancelSearch() 
        searchBar.resignFirstResponder()
    }

}

//MARK: - TaskListViewProtocol

extension TaskListViewController: TaskListViewProtocol {
    func reloadData() {
        tasksCountLabel.text = ("\(presenter.taskCount ?? 0) tasks")
            self.taskListTableView.reloadData()
    }
    
    func displayShareTask(_ taskDescription: String) {
        sharedActivitiIndicator.startAnimating()
        let controller = UIActivityViewController(
            activityItems: [taskDescription],
          applicationActivities: nil
        )
        DispatchQueue.main.async{
            self.present(controller, animated: true, completion: nil)
            if controller.isViewLoaded  {
                self.sharedActivitiIndicator.stopAnimating()
            }
        }
    }
}

extension TaskListViewController: TaskDetailsDelegate {
    func didUpdatedTasks() {
        presenter.updateTask()
    }
}
