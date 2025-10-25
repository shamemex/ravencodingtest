//
//  ArticleDetailView.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 25/10/25.
//

import SwiftUI

struct ArticleDetailView: View {
    var article: Article
    var body: some View {
        VStack() {
            AsyncImage(
                url: URL(string: article.media.first?.mediaMetadata[1].url ?? "")
            ) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height * 0.35
                    )
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .italic()
                Text(article.byline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(article.abstract)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
            .padding()
            Spacer()
        }
    }
}

#Preview {
    ArticleDetailView(article: Article.exampleArticle)
}
