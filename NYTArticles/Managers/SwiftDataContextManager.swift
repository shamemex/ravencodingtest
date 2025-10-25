//
//  SwiftDataContextManager.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 24/10/25.
//
import SwiftData

final class SwiftDataContextManager {
    static let shared = SwiftDataContextManager()
    
    var container: ModelContainer?
    var context: ModelContext?
    
    private init() {
        do {
            container = try ModelContainer(for: ViewedArticle.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
            
            if let container {
                context = ModelContext(container)
                context?.autosaveEnabled = false
            }
        } catch {
            debugPrint("Error initializing database container:", error)
        }
    }
}
