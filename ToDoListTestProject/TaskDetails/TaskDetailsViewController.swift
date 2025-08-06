//
//  TaskDetailsViewController.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 02.08.2025.
//

import UIKit

protocol TaskDetailsViewProtocol: AnyObject {
    func displayTaskDetails(task: TaskDetailsEntity)
    func didUpdateTask()
}

protocol TaskDetailsDelegate: AnyObject {
    func didUpdatedTasks()
}

class TaskDetailsViewController: UIViewController {
    
    var presenter: TaskDetailsPresenterProtocol!
    weak var delegate: TaskDetailsDelegate?
    
    var titleTextView: UITextView!
    var dateTextField: UITextField!
    var descriptionTextView: UITextView!
    var datePicker: UIDatePicker!
    var gestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.showTask()
        configureTextFields()
        configureGestureRecognizer()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        saveTask()
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
        titleTextView.addDoneButtonToKeyboard()
        titleTextView.text = "Enter task title..."
        titleTextView.delegate = self
        
        datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        dateTextField = UITextField()
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.backgroundColor = .clear
        dateTextField.textColor = .darkGray
        dateTextField.font = UIFont.systemFont(ofSize: 12)
        dateTextField.inputView = datePicker
        dateTextField.addDoneButtonToKeyboard()
        dateTextField.delegate = self
        updateTextField(with: datePicker.date)
        
        descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textColor = .darkGray
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.addDoneButtonToKeyboard()
        descriptionTextView.text = "Enter description..."
        descriptionTextView.delegate = self
    }
    
    private func configureGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(didTapScreen))
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
    
    private func updateTextField(with date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formatter.string(from: date)
    }
    
    private func saveTask() {
        guard let dateText = dateTextField.text else { return }
        if titleTextView.text != "" && titleTextView.text != "Enter task title..." {
            let title = titleTextView.text!
            let description = descriptionTextView.text != "Enter description..." ? descriptionTextView.text : nil
            
            presenter.didEndEditing(title: title, date: dateText, description: description)
        }
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        updateTextField(with: sender.date)
    }
    
    @objc private func didTapScreen() {
        titleTextView.resignFirstResponder()
        dateTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        view.removeGestureRecognizer(gestureRecognizer)
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
        view.addGestureRecognizer(gestureRecognizer)
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.addGestureRecognizer(gestureRecognizer)
    }
}

//MARK: - TaskDetailsViewProtocol

extension TaskDetailsViewController: TaskDetailsViewProtocol {
    func displayTaskDetails(task: TaskDetailsEntity) {
        DispatchQueue.main.async {
            self.titleTextView.text = task.title
            self.titleTextView.textColor = .white
            if task.description != "" {
                self.descriptionTextView.text = task.description
            }
            if self.descriptionTextView.text != "Enter description..." {
                self.descriptionTextView.textColor = .white
            }
            self.dateTextField.text = task.date
        }
    }
    
    func didUpdateTask() {
        delegate?.didUpdatedTasks()
    }
}
