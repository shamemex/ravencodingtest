//
//  SwiftDataContextManagerTests.swift
//  NYTArticlesTests
//
//  Created by Emmanuel Martínez on 25/10/25.
//

import XCTest
import SwiftData
@testable import NYTArticles

final class SwiftDataContextManagerTests: XCTestCase {
    
    func testSharedInstance() {
        // When
        let instance1 = SwiftDataContextManager.shared
        let instance2 = SwiftDataContextManager.shared
        
        // Then
        XCTAssertNotNil(instance1)
        XCTAssertTrue(instance1 === instance2, "Should return same instance")
    }
    
    func testContainerInitialization() {
        // When
        let manager = SwiftDataContextManager.shared
        
        // Then
        XCTAssertNotNil(manager.container, "Container should be initialized")
        
        if let schema = manager.container?.configurations.first?.schema {
            XCTAssertTrue(schema.entities.contains { $0.name == String(describing: Article.self) },
                         "Container should be configured for ViewedArticle model")
        } else {
            XCTFail("Container schema should exist")
        }
    }
    
    func testContextInitialization() {
        // When
        let manager = SwiftDataContextManager.shared
        
        // Then
        XCTAssertNotNil(manager.context, "Context should be initialized")
        XCTAssertFalse(manager.context?.autosaveEnabled ?? true, "Autosave should be disabled")
        XCTAssertTrue(manager.context?.container === manager.container, "Context should be associated with container")
    }
}
