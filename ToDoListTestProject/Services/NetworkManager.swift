//
//  NetworkManager.swift
//  ToDoListTestProject
//
//  Created by Artem Kudryavtsev on 04.08.2025.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
        
    func fetchData(completion: @escaping (Tasks) -> Void) {
        guard let url = Bundle.main.url(forResource: "todos", withExtension: "json") else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let tasks = try JSONDecoder().decode(Tasks.self, from: data)
                DispatchQueue.main.async {
                    completion(tasks)
                }
            } catch {
                print("Failed serializing JSON: \(error)")
            }
        }.resume()
    }
}
