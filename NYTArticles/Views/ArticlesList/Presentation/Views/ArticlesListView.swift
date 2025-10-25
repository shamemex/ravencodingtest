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
    @State private var isShowingBanner = false

    var body: some View {
        ZStack {
            NavigationSplitView {
                List {
                    if isShowingBanner {
                        BannerView(isShowingBanner: $isShowingBanner)
                            .transition(.slide)
                    }
                    ForEach(viewModel.articles) { article in
                        NavigationLink {
                            ArticleListItemView(article: article)
                        } label: {
                            ArticleListItemView(article: article)
                        }
                    }
                }
                .navigationTitle("Most Viewed Articles")
                .refreshable {
                    await fetchArticles()
                }
            } detail: {
                Text("Select an item")
            }
            .task {
                await fetchArticles()
            }
            
            if loadingError && viewModel.articles.isEmpty {
                ErrorView()
            }
            
            if isLoading {
                ProgressView()
            }
        }
    }
    
    func showBanner() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation {
                isShowingBanner = false
            }
        }
    }
    
    func fetchArticles() async {
        do {
            try await viewModel.fetchArticles()
            isLoading = false
        } catch {
            loadingError = true
            showBanner()
            isShowingBanner = true
            isLoading = false
        }
    }
}

#Preview {
    ArticlesListView(
        viewModel: ViewedArticlesViewModelMock()
    )
}
