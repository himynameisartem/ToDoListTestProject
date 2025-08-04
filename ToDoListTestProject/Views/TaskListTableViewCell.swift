//
//  TaskListTableViewCell.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 04.08.2025.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    let checkmarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        return label
    }()
    
    var checkmarkButtonAction: (() -> Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        
        checkmarkButton.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            checkmarkButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            checkmarkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 24),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 24),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            dateLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 12),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    func configure(task: ToDos) {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let symbolName = task.completed ? "checkmark.circle" : "circle"
        let symbolColor = task.completed ? UIColor.yellow : UIColor.darkGray
        let image = UIImage(systemName: symbolName, withConfiguration: config)
        checkmarkButton.setImage(image, for: .normal)
        checkmarkButton.tintColor = symbolColor
        titleLabel.text = task.todo
        descriptionLabel.text = task.description ?? ""
        dateLabel.text = task.date ?? ""
    }
    
    @objc func checkmarkTapped(_ sender: UIButton) {
        checkmarkButtonAction?()
    }
}
