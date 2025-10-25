//
//  ArticlesLocalDataSourceTests.swift
//  NYTArticlesTests
//
//  Created by Emmanuel Martínez on 25/10/25.
//

import XCTest
import SwiftData
@testable import NYTArticles

@MainActor
final class ArticlesLocalDataSourceTests: XCTestCase {
    private var container: ModelContainer!
    private var dataSource: ArticlesLocalDataSource!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        container = try ModelContainer(for: Article.self,
                                       configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        dataSource = ArticlesLocalDataSource(container: container, context: container.mainContext)
    }
    
    override func tearDownWithError() throws {
        dataSource = nil
        container = nil
        try super.tearDownWithError()
    }
    
    func testFetchInitiallyEmpty() {
        // When
        let results = dataSource.fetch()
        
        // Then
        XCTAssertEqual(results.count, 0, "Fetch on new in-memory store should be empty")
    }
    
    func testInsertIncreasesCount() {
        // When
        let article = Article(
            id: 1,
            title: "The White House Wrecking Ball",
            byline: "By Jess Bidgood",
            publishedDate: Date(),
            abstract: "President Trump’s demolition of the East Wing has struck a nerve in Washington and beyond."
        )
        dataSource.insert(article)
        
        let results = dataSource.fetch()
        // Then
        XCTAssertEqual(results.count, 1, "Inserting one article should result in one stored article")
    }
    
    func testDeleteRemovesEntity() {
        // When
        let article = Article(
            id: 1,
            title: "The White House Wrecking Ball",
            byline: "By Jess Bidgood",
            publishedDate: Date(),
            abstract: "President Trump’s demolition of the East Wing has struck a nerve in Washington and beyond."
        )
        
        // Then
        dataSource.insert(article)
        XCTAssertEqual(dataSource.fetch().count, 1)
        
        dataSource.delete(article)
        XCTAssertEqual(dataSource.fetch().count, 0, "Deleting the article should remove it from storage")
    }
    
    func testBatchInsertAddsMultiple() {
        // When
        let articles = (0..<3).enumerated().map { index, _ in Article(
            id: index,
            title: "The White House Wrecking Ball",
            byline: "By Jess Bidgood",
            publishedDate: Date(),
            abstract: "President Trump’s demolition of the East Wing has struck a nerve in Washington and beyond."
        ) }
        dataSource.batchInsert(articles: articles)
        
        // Then
        let results = dataSource.fetch()
        XCTAssertEqual(results.count, 3, "Batch insert should add all provided articles")
    }
}
