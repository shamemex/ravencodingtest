//
//  NYTArticlesApp.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 24/10/25.
//

import SwiftUI

@main
struct NYTArticlesApp: App {
    var body: some Scene {
        WindowGroup {
            ArticlesListView(
                viewModel: ArticlesListViewModel(
                    localDataSource: ArticlesLocalDataSource(
                        container: SwiftDataContextManager.shared.container,
                        context: SwiftDataContextManager.shared.context
                    ),
                    remoteDataSource: ArticlesService()
                )
            )
        }
    }
}
