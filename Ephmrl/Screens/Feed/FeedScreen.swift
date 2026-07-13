//
//  FeedScreen.swift
//  Ephmrl
//
//  Created by Аскольд on 14.07.2026.
//

import SwiftUI

struct FeedScreen: View {
    @State private var scrollY: CGFloat = 0
    @State private var collapsed: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(spacing: Theme.spacing.lg) {
                    ForEach(1...10, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Theme.colors.foregroundTransparent)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                    }
                }
                .padding(.horizontal, Theme.spacing.lg)
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
