//
//  ArticlesLocalDataSource.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 24/10/25.
//

import Foundation
import SwiftData

@MainActor
class ArticlesLocalDataSource {
    private let container: ModelContainer?
    private let context: ModelContext?
    
    init(container: ModelContainer?, context: ModelContext?) {
        self.container = container
        self.context = context
    }
}

extension ArticlesLocalDataSource {
    func fetch() -> [ViewedArticle] {
        let fetchDescriptor = FetchDescriptor<ViewedArticle>(sortBy: [SortDescriptor(\.createdAt, order: .forward)])
        let articles = try? self.container?.mainContext.fetch(fetchDescriptor)
        return articles ?? []
    }
    
    func insert(_ entity: ViewedArticle) {
        self.container?.mainContext.insert(entity)
        try? self.container?.mainContext.save()
    }
    
    func delete(_ entity: ViewedArticle) {
        self.container?.mainContext.delete(entity)
        try? self.container?.mainContext.save()
    }
    
    func deleteOlder() {
        let olderThanXDays = Calendar.current.date(byAdding: .day, value: -2, to: .now) ?? Date.now
        try? self.container?.mainContext.delete(model: ViewedArticle.self, where: #Predicate { $0.createdAt < olderThanXDays })
        try? self.container?.mainContext.save()
    }
    
    func batchInsert(articles: [ViewedArticle]) {
        articles.forEach { article in
            insert(article)
        }
    }
}
