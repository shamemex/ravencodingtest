//
//  ArticlesListView.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 24/10/25.
//

import SwiftUI

struct ArticlesListView<ViewModel>: View where ViewModel: ArticlesListViewModelProtocol {
    @StateObject var viewModel: ViewModel
    @State private var loadingError = false
    @State private var isLoading = true

    var body: some View {
        ZStack {
            NavigationSplitView {
                List {
                    ForEach(viewModel.articles) { article in
                        NavigationLink {
                            ArticleListItemView(article: article)
                        } label: {
                            ArticleListItemView(article: article)
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
    ArticlesListView(
        viewModel: ViewedArticlesViewModelMock()
    )
}
