//
//  ViewedArticlesViewModel.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 24/10/25.
//
import SwiftUI

class ViewedArticlesViewModel: ObservableObject {
    private let localDataSource: ArticlesLocalDataSource
    private let remoteDataSource: ViewedArticlesService
    @Published var articles: [ViewedArticle] = [ViewedArticle]()
    
    init(
        localDataSource: ArticlesLocalDataSource,
        remoteDataSource: ViewedArticlesService
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    @MainActor
    func fetchArticles() async throws {
        localDataSource.deleteOlder()
        let localArticles = localDataSource.fetch()
        var remoteArticles: [ViewedArticle] = []
        var mergedArticles: Set<ViewedArticle>
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
    func fetchRemoteArticles() async throws -> [ViewedArticle] {
        try await remoteDataSource.fetchViewedArticles()
    }
}
