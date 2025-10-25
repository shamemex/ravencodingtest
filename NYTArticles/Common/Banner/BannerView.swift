//
//  BannerView.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 25/10/25.
//

import SwiftUI

struct BannerView: View {
    @Binding var isShowingBanner: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.blue)
                .frame(
                    width: UIScreen.main.bounds.width * 0.85,
                    height: UIScreen.main.bounds.height * 0.09
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .top),
                    removal: .move(edge: .top)
                ))
            
            HStack {
                Text("We couldn't retrieve most recent articles, try again later")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding()
                Button {
                    withAnimation {
                        isShowingBanner.toggle()
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                }
            }
            .padding()
        }
    }
}

#Preview {
    BannerView(isShowingBanner: .constant(true))
}
