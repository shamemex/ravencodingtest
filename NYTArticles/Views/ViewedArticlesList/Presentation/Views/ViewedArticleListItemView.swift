//
//  ViewedArticleListItemView.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 24/10/25.
//

import SwiftUI

struct ViewedArticleListItemView: View {
    var article: ViewedArticle
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .font(.title2)
                .fontWeight(.bold)
            Text(article.abstract)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            Text("\(article.byline != "" ? article.byline + " on" : "") \(article.publishedDate, format: Date.FormatStyle(date: .abbreviated, time: .omitted))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ViewedArticleListItemView(article: ViewedArticle.exampleArticle)
}
