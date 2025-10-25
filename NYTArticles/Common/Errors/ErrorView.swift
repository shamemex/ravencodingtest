//
//  ErrorView.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 24/10/25.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack {
            Image(systemName: "xmark.icloud")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .accentColor(.blue)
            Text("An error ocurred while retrieving articles.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
            Text("Pull to retry")
        }
        .padding()
    }
}

#Preview {
    ErrorView()
}
