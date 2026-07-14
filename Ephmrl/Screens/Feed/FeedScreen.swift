//
//  FeedScreen.swift
//  Ephmrl
//
//  Created by Аскольд on 14.07.2026.
//

import SwiftUI

struct FeedScreen: View {
    @Environment(\.customScreen) private var screenSize
    @State private var scrollY: CGFloat = 0
    @State private var collapsed: Bool = false
    
    let articles: [Article] = FeedMockData.articles
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(spacing: Theme.spacing.xs) {
                    ForEach(Array(articles.enumerated()), id: \.element.id) { index, article in
                        FeedArticleView(article: article, targetWidth: screenSize.width)
                        
                        if index < articles.count - 1 {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Theme.colors.text.opacity(0.1))
                                .frame(height: 1)
                                .padding(.horizontal, Theme.spacing.xxxl)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y + geometry.contentInsets.top
            } action: { oldValue, newValue in
                withAnimation(.normalSpring) {
                    self.collapsed = newValue > Theme.spacing.xxxl
                }
                self.scrollY = newValue
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                FeedHeaderView(scrollY: scrollY, collapsed: collapsed)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                FeedFooterView()
            }
            
            if collapsed {
                FeedFloatHeaderView()
                    .transition(AnyTransition.opacity.combined(with: .blur(radius: 4)))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
