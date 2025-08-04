//
//  Task.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 04.08.2025.
//

import Foundation

struct Task: Codable {
    let limit: Int
    let skip: Int
    let todos: [ToDos]
}

struct ToDos: Codable {
    var id: Int
    var todo: String
    var completed: Bool
    var userId: Int
    var description: String?
    var date: String?
}
