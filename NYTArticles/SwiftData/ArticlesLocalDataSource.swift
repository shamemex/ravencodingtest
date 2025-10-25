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
    func fetch() -> [Article] {
        let fetchDescriptor = FetchDescriptor<Article>(sortBy: [SortDescriptor(\.createdAt, order: .forward)])
        let articles = try? self.container?.mainContext.fetch(fetchDescriptor)
        return articles ?? []
    }
    
    func insert(_ entity: Article) {
        self.container?.mainContext.insert(entity)
        try? self.container?.mainContext.save()
    }
    
    func delete(_ entity: Article) {
        self.container?.mainContext.delete(entity)
        try? self.container?.mainContext.save()
    }
    
    func deleteOlder() {
        let olderThanXDays = Calendar.current.date(byAdding: .day, value: -2, to: .now) ?? Date.now
        try? self.container?.mainContext.delete(model: Article.self, where: #Predicate { $0.createdAt < olderThanXDays })
        try? self.container?.mainContext.save()
    }
    
    func batchInsert(articles: [Article]) {
        articles.forEach { article in
            insert(article)
        }
    }
}
