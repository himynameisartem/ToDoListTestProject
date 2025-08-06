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
    var todo: String
    var completed: Bool
    var description: String?
    var date: String?
}

extension ToDos: Equatable {
    static func == (lhs: ToDos, rhs: ToDos) -> Bool {
        return lhs.todo == rhs.todo &&
               lhs.description == rhs.description &&
               lhs.date == rhs.date
    }
}
