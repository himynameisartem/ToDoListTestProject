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

extension ToDos: Equatable {
    static func == (lhs: ToDos, rhs: ToDos) -> Bool {
        return lhs.id == rhs.id &&
               lhs.todo == rhs.todo &&
               lhs.userId == rhs.userId &&
               lhs.description == rhs.description &&
               lhs.date == rhs.date
    }
}
