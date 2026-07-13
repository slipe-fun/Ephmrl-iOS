//
//  FeedHeaderView.swift
//  Ephmrl
//
//  Created by Аскольд on 14.07.2026.
//

import SwiftUI

struct FeedHeaderView: View {
    let scrollY: CGFloat
    let collapsed: Bool
    
    @Environment(\.customSafeArea) private var safeArea
    
    var body: some View {
        HStack {
            Text("Feed")
                .font(Theme.font.largeTitle)
                .foregroundStyle(Theme.colors.text)
                
            Spacer()
        }
        .padding(.top, Theme.spacing.xxxl + safeArea.top)
        .padding(.horizontal, Theme.spacing.lg)
        .padding(.bottom, Theme.spacing.md)
        .offset(y: min(-scrollY, -scrollY / 4))
        .ignoresSafeArea(edges: .top)
        .opacity(collapsed ? 0 : 1)
    }
}

struct FeedFloatHeaderView: View {
    @Environment(\.customSafeArea) var safeArea
    
    var body: some View {
        ZStack(alignment: .center) {
            Text("Feed")
                .font(Theme.font.title4)
                .foregroundStyle(Theme.colors.text)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Theme.spacing.md + safeArea.top)
        .padding(.horizontal, Theme.spacing.lg)
        .padding(.bottom, Theme.spacing.xxl)
        .ignoresSafeArea(edges: .top)
        .topGradientBackground(color: Theme.colors.panelBackground)
    }
}
