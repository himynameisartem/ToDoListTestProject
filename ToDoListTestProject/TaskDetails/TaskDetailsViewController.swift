//
//  TaskDetailsViewController.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import UIKit

protocol TaskDetailsViewProtocol: AnyObject {
    func displayTaskDetails(task: TaskDetailsEntity)
}

class TaskDetailsViewController: UIViewController {
    
    var presenter: TaskDetailsPresenterProtocol!
    
    var titleTextView: UITextView!
    var dateTextField: UITextField!
    var descriptionTextView: UITextView!
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.showTask()
        configureTextFields()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(titleTextView)
        view.addSubview(dateTextField)
        view.addSubview(descriptionTextView)
    }
    
    private func configureTextFields() {
        titleTextView = UITextView()
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.backgroundColor = .clear
        titleTextView.textColor = .darkGray
        titleTextView.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        titleTextView.isScrollEnabled = false
        titleTextView.text = "Enter task title..."
        titleTextView.delegate = self
        
        datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        
        dateTextField = UITextField()
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.backgroundColor = .clear
        dateTextField.textColor = .darkGray
        dateTextField.font = UIFont.systemFont(ofSize: 12)
        dateTextField.text = datePicker.description
        dateTextField.inputView = datePicker
        dateTextField.delegate = self
        
        
        descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textColor = .darkGray
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.text = "Enter description..."
        descriptionTextView.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 54),
            
            dateTextField.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 0),
            dateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            dateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateTextField.heightAnchor.constraint(equalToConstant: 30),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 0),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }
}

//MARK: - UITextViewDelegate

extension TaskDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                if textView == titleTextView {
                    constraint.constant = max(54, size.height)
                } else {
                    constraint.constant = max(44, size.height)
                }
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .darkGray {
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .darkGray
            
            if textView == titleTextView {
                textView.text = "Enter task title..."
            } else if textView == descriptionTextView {
                textView.text = "Enter description..."
            }
        }
    }
}

//MARK: - UITextFieldDelegate

extension TaskDetailsViewController: UITextFieldDelegate {
    
}

//MARK: - TaskDetailsViewProtocol

extension TaskDetailsViewController: TaskDetailsViewProtocol {
    func displayTaskDetails(task: TaskDetailsEntity) {
        DispatchQueue.main.async {
            self.titleTextView.text = task.title
            if task.description != "" {
                self.descriptionTextView.text = task.description
            }
            self.dateTextField.text = task.date
            self.titleTextView.textColor = .white
        }
    }
}
