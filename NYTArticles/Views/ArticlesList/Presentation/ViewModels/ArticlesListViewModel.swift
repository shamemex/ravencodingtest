//
//  ArticlesListViewModel.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 24/10/25.
//
import SwiftUI

protocol ArticlesListViewModelProtocol: ObservableObject {
    var articles: [Article] { get set }
    func fetchArticles() async throws
}

class ArticlesListViewModel: ArticlesListViewModelProtocol {
    private let localDataSource: ArticlesLocalDataSource
    private let remoteDataSource: ArticlesService
    @Published var articles: [Article] = [Article]()
    
    init(
        localDataSource: ArticlesLocalDataSource,
        remoteDataSource: ArticlesService
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    @MainActor
    func fetchArticles() async throws {
        localDataSource.deleteOlder()
        let localArticles = localDataSource.fetch()
        var remoteArticles: [Article] = []
        var mergedArticles: Set<Article>
        do {
            remoteArticles = try await fetchRemoteArticles()
            
            mergedArticles = Set(localArticles + remoteArticles)
            articles = Array(mergedArticles)
        } catch {
            mergedArticles = Set(localArticles)
            articles = Array(mergedArticles)
            throw error
        }
        
        // Not possible to run in background due to ModelContext isolation in main thread
        localDataSource.batchInsert(articles: articles)
    }
    
    @MainActor
    func fetchRemoteArticles() async throws -> [Article] {
        try await remoteDataSource.fetchArticles()
    }
}

class ViewedArticlesViewModelMock: ArticlesListViewModelProtocol {
    @Published var articles: [Article] = [Article]()
    
    func fetchArticles() async throws {
        articles = [Article.exampleArticle]
    }
}
