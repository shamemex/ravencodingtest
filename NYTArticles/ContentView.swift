//
//  ContentView.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 24/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var viewModel = ViewedArticlesViewModel(
        localDataSource: ArticlesLocalDataSource(
            container: SwiftDataContextManager.shared.container,
            context: SwiftDataContextManager.shared.context
        ),
        remoteDataSource: ViewedArticlesService()
    )
    @State var loadingError = false
    @State var isLoading = true

    var body: some View {
        ZStack {
            NavigationSplitView {
                List {
                    ForEach(viewModel.articles) { article in
                        NavigationLink {
                            ViewedArticleListItemView(article: article)
                        } label: {
                            ViewedArticleListItemView(article: article)
                        }
                    }
                }
                .navigationTitle("Most Viewed Articles")
            } detail: {
                Text("Select an item")
            }
            .task {
                do {
                    try await viewModel.fetchArticles()
                    isLoading = false
                } catch {
                    self.loadingError = true
                    isLoading = false
                }
            }
            
            if loadingError && viewModel.articles.isEmpty {
                ErrorView()
            }
            
            if isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    ContentView()
}
