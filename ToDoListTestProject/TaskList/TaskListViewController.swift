//
//  TaskListViewController.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import UIKit

protocol TaskListViewProtocol: AnyObject {
    func reloadData()
}

class TaskListViewController: UIViewController {
    
    var presenter: TaskListPresenterProtocol!
    private let configurator: TaskListConfigiratorProtocol = TaskListConfigirator()
    
    var taskListTableView: UITableView!
    var bottomBarView: UIView!
    var tasksCountLabel: UILabel!
    var addTaskButton: UIButton!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(viewController: self)
        presenter.viewDidLoad()
        configureNavigationBar()
        configureSearchController()
        configureBottomBarView()
        configureTaskListTableView()
        setuUI()
        setupConstraints()
    }
    
    private func setuUI() {
        
        view.backgroundColor = .darkGray
        view.addSubview(bottomBarView)
        bottomBarView.addSubview(tasksCountLabel)
        bottomBarView.addSubview(addTaskButton)
        view.addSubview(taskListTableView)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Tasks"
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureSearchController() {
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
        searchController.searchBar.searchTextField.textColor = .lightGray
        searchController.searchBar.delegate = self
    }
    
    private func configureBottomBarView() {
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
        addTaskButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func configureTaskListTableView() {
        taskListTableView = UITableView()
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        taskListTableView.translatesAutoresizingMaskIntoConstraints = false
        taskListTableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: "TaskListTableViewCell")
        taskListTableView.backgroundColor = .black
        taskListTableView.separatorColor = .darkGray
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 49),
            
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
    
    @objc private func addButtonTapped(_ sender: UIButton) {
        print("Add button tapped")
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
            self?.presenter.taskCompletionToggle(at: task)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        106
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
       
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = .darkGray
        }
        
        let configuration = UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { action in
            let addTask = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { action in
                
            }
            let editTask = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
                
            }
            let deleteTask = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
               
            }
            return UIMenu(title: "", children: [addTask, editTask, deleteTask])
        }
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration,
                   animator: UIContextMenuInteractionAnimating?) {
        guard let indexPath = configuration.identifier as? IndexPath else { return }
        animator?.addCompletion {
            if let cell = tableView.cellForRow(at: indexPath) {
                UIView.animate(withDuration: 0.3) {
                    cell.contentView.backgroundColor = .clear
                }
            }
        }
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
        DispatchQueue.main.async {
            self.taskListTableView.reloadData()
        }
    }
}
