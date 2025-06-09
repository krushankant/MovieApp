//
//  ItemTests.swift
//  MovieAppTests
//

import XCTest
import SwiftData
@testable import MovieApp

final class ItemTests: XCTestCase {
    var modelContainer: ModelContainer!
    var context: ModelContext!
    
    override func setUpWithError() throws {
        modelContainer = try ModelContainer(
            for: Item.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        context = ModelContext(modelContainer)
    }
    
    override func tearDownWithError() throws {
        modelContainer = nil
        context = nil
    }
    
    func testItemInitialization() throws {
        let now = Date()
        let item = Item(timestamp: now)
        XCTAssertEqual(item.timestamp, now)
    }
    
    func testItemPersistence() throws {
        let now = Date()
        let item = Item(timestamp: now)
        context.insert(item)
        
        try context.save()
        
        let descriptor = FetchDescriptor<Item>()
        let results = try context.fetch(descriptor)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.timestamp, now)
    }
}
