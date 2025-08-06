//
//  TaskListTableViewCell.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 04.08.2025.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    let checkmarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
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
        backgroundColor = .black
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(dateLabel)
        contentView.addSubview(checkmarkButton)
        
        checkmarkButton.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            checkmarkButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            checkmarkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 24),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 24),
            containerView.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 7),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
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
    
    
    
    func configure(task: Task) {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let symbolName = task.isCompleted ? "checkmark.circle" : "circle"
        let symbolColor = task.isCompleted ? UIColor.yellow : UIColor.darkGray
        let image = UIImage(systemName: symbolName, withConfiguration: config)
        checkmarkButton.setImage(image, for: .normal)
        checkmarkButton.tintColor = symbolColor
        titleLabel.attributedText = underlineString(isComleted: task.isCompleted, text: task.title)
        descriptionLabel.text = task.details ?? ""
        dateLabel.text = task.date ?? ""
        
        if task.isCompleted {
            titleLabel.textColor = .systemGray
            descriptionLabel.textColor = .darkGray
        } else {
            titleLabel.textColor = .white
            descriptionLabel.textColor = .white
        }
    }
    
    private func underlineString(isComleted: Bool, text: String?) -> NSAttributedString {
        if isComleted {
            return NSAttributedString(string: text ?? "", attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.systemGray
            ])
        } else {
            return NSMutableAttributedString(string: text ?? "")
        }
    }
    
    @objc func checkmarkTapped(_ sender: UIButton) {
        checkmarkButtonAction?()
    }
}
