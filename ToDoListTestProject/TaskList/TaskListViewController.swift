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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

extension TaskListViewController: TaskListViewProtocol {
    func reloadData() {
        
    }
}
