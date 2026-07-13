//
//  FeedFooterView.swift
//  Ephmrl
//
//  Created by Аскольд on 14.07.2026.
//

import SwiftUI

public enum FooterTab: Hashable {
    case feed
    case profile
}

struct FeedFooterView: View {
    @State private var selectedTab: FooterTab = .feed
    
    private let items: [SwitcherViewItem<FooterTab>] = [
        .init(value: .feed, image: Image("compass_icon")),
        .init(value: .profile, image: Image("person.circle_icon"))
    ]
    
    var body: some View {
        HStack {
            SwitcherView(
                items: items,
                selection: $selectedTab
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Theme.spacing.md)
        .padding(.horizontal, Theme.spacing.xl)
        .padding(.bottom, Theme.spacing.xl)
        .bottomGradientBackground(color: Theme.colors.panelBackground)
    }
}
