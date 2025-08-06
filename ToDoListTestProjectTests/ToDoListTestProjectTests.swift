//
//  ToDoListTestProjectTests.swift
//  ToDoListTestProjectTests
//
//  Created by Artem Kudryavtsev on 06.08.2025.
//

import XCTest
import CoreData
@testable import ToDoListTestProject

class TaskManagerTests: XCTestCase {
    
    var taskManager: TaskManager!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        let container = NSPersistentContainer(name: "Task")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        
        mockContext = container.viewContext
        taskManager = TaskManager.shared
    }
    
    override func tearDown() {
        taskManager = nil
        mockContext = nil
        super.tearDown()
    }
    
    // MARK: - Add Task Tests
    
    func testAddTaskWithValidDataTaskIsAdded() {
        let expectation = XCTestExpectation(description: "addTask")
        let title = "Test Task"
        let detail = "Test Detail"
        let date = "01/01/2024"
        taskManager.addTask(title: title, detail: detail, date: date) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(taskManager.tasks.first?.title, title)
        XCTAssertEqual(taskManager.tasks.first?.details, detail)
        XCTAssertEqual(taskManager.tasks.first?.date, date)
        XCTAssertFalse(taskManager.tasks.first?.isCompleted ?? true)
    }
    
    func testAddTaskWithEmptyTitleTaskIsStillAdded() {
        let expectation = XCTestExpectation(description: "addTask")
        let title = ""
        let detail = "Test Detail"
        let date = "01/01/2024"
        
        taskManager.addTask(title: title, detail: detail, date: date) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(taskManager.tasks.first?.title, title)
    }
    
    // MARK: - Update Task Tests
    
    func testUpdateTaskWithValidDataTaskIsUpdated() {
        let addExpectation = XCTestExpectation(description: "addTask")
        let updateExpectation = XCTestExpectation(description: "updateTask")
        
        taskManager.addTask(title: "Old Title", detail: "Old Detail", date: "01/01/2024") {
            addExpectation.fulfill()
        }
        
        wait(for: [addExpectation], timeout: 2.0)
        
        guard let task = taskManager.tasks.first else {
            XCTFail("Task was not added")
            return
        }
        
        let newTitle = "New Title"
        let newDetail = "New Detail"
        let newDate = "02/02/2024"
        
        taskManager.updateTask(task, title: newTitle, detail: newDetail, date: newDate, isCompleted: true) {
            updateExpectation.fulfill()
        }
        
        wait(for: [updateExpectation], timeout: 2.0)
        XCTAssertEqual(taskManager.tasks.first?.title, newTitle)
        XCTAssertEqual(taskManager.tasks.first?.details, newDetail)
        XCTAssertEqual(taskManager.tasks.first?.date, newDate)
        XCTAssertTrue(taskManager.tasks.first?.isCompleted ?? false)
    }
    
    // MARK: - Toggle Task Completion Tests
    
    func testCompleteToggleChangesTaskCompletionStatus() {
        let addExpectation = XCTestExpectation(description: "addTask")
        let toggleExpectation = XCTestExpectation(description: "toggle")
        
        taskManager.addTask(title: "Test Task", detail: "Detail", date: "01/01/2024") {
            addExpectation.fulfill()
        }
        
        wait(for: [addExpectation], timeout: 2.0)
        
        guard let task = taskManager.tasks.first else {
            XCTFail("Task was not added")
            return
        }
        
        let initialStatus = task.isCompleted
        
        taskManager.completeToggle(task) {
            toggleExpectation.fulfill()
        }
        
        wait(for: [toggleExpectation], timeout: 2.0)
        XCTAssertNotEqual(taskManager.tasks.first?.isCompleted, initialStatus)
    }
    
    // MARK: - Search Tasks Tests
    
    func testSearchTasksWithMatchingQueryReturnsMatchingTasks() {
        let addExpectation1 = XCTestExpectation(description: "firstTask")
        let addExpectation2 = XCTestExpectation(description: "secondTask")
        let searchExpectation = XCTestExpectation(description: "search")
        
        taskManager.addTask(title: "Liverpool fc", detail: "Detail", date: "06/08/2025") {
            addExpectation1.fulfill()
        }
        
        wait(for: [addExpectation1], timeout: 2.0)
        
        taskManager.addTask(title: "Man City", detail: "Detail", date: "07/09/2025") {
            addExpectation2.fulfill()
        }
        
        wait(for: [addExpectation2], timeout: 2.0)
        
        var searchResults: [Task] = []
        
        taskManager.searchTasks(by: "Liverpool") { results in
            searchResults = results
            searchExpectation.fulfill()
        }
        
        wait(for: [searchExpectation], timeout: 2.0)
        XCTAssertEqual(searchResults.first?.title, "Liverpool fc")
    }
    
    func testSearchTasksWithNonMatchingQueryReturnsEmptyArray() {
        let addExpectation = XCTestExpectation(description: "task")
        let searchExpectation = XCTestExpectation(description: "Search")
        
        taskManager.addTask(title: "Liverpool", detail: "Detail", date: "01/01/2024") {
            addExpectation.fulfill()
        }
        
        wait(for: [addExpectation], timeout: 2.0)
        
        var searchResults: [Task] = []
        
        taskManager.searchTasks(by: "Arsenal") { results in
            searchResults = results
            searchExpectation.fulfill()
        }
        
        wait(for: [searchExpectation], timeout: 2.0)
        XCTAssertEqual(searchResults.count, 0)
    }
}
