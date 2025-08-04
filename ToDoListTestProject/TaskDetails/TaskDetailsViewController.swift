//
//  TaskDetailsViewController.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import UIKit

protocol TaskDetailsViewProtocol: AnyObject {
    
}

class TaskDetailsViewController: UIViewController {
    
    var presenter: TaskDetailsPresenterProtocol!
    private var configurator: TaskDetailsConfiguratorProtocol = TaskDetailsConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        configurator.configure(viewController: self)
    }
    
}

extension TaskDetailsViewController: TaskDetailsViewProtocol {
    
}
