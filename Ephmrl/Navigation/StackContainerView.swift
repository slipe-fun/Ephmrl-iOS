//
//  StackContainerView.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

struct StackContainerView<Route: Hashable, Root: View, Pushed: View>: View {
    let path: [Route]
    let isInteractive: Bool
    let safeArea: EdgeInsets
    let onPop: () -> Void
    let root: () -> Root
    let content: (Route) -> Pushed

    init(
        path: [Route],
        isInteractive: Bool,
        safeArea: EdgeInsets,
        onPop: @escaping () -> Void,
        @ViewBuilder root: @escaping () -> Root,
        @ViewBuilder content: @escaping (Route) -> Pushed
    ) {
        self.path = path
        self.isInteractive = isInteractive
        self.safeArea = safeArea
        self.onPop = onPop
        self.root = root
        self.content = content
    }

    @State private var dragOffset: CGFloat = 0
    @State private var isSwiping: Bool = false

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let maxRadius = safeArea.top > 20 ? safeArea.top - 4 : 0.0
            let isRootRendered = path.count < 2
            let hasPushedRoute = !path.isEmpty

            let standardProgress: CGFloat = {
                guard hasPushedRoute else { return 0.0 }
                return isSwiping ? max(0, 1.0 - dragOffset / width) : 1.0
            }()

            let rootOffset: CGFloat = -width * 0.3 * standardProgress

            ZStack {
                root()
                    .modifier(ChatsRootModifier(
                        offset: rootOffset,
                        isSettingsTransition: false,
                        settingsProgress: 0,
                        standardProgress: standardProgress,
                        cornerRadius: maxRadius
                    ))
                    .opacity(isRootRendered ? 1.0 : 0.0)
                    .allowsHitTesting(isInteractive && isRootRendered)
                    .zIndex(1)

                ForEach(Array(path.enumerated()), id: \.offset) { index, route in
                    let isTopRoute = index == path.count - 1
                    let isPreviousRoute = index == path.count - 2
                    let isRendered = index >= path.count - 2

                    let currentProgress: CGFloat = {
                        if isTopRoute {
                            return isSwiping ? (1.0 - dragOffset / width) : 1.0
                        } else if isPreviousRoute {
                            return isSwiping ? dragOffset / width : 0.0
                        }
                        return 0.0
                    }()

                    let currentOffset: CGFloat = {
                        if isTopRoute {
                            return isSwiping ? dragOffset : 0
                        } else if isPreviousRoute {
                            return isSwiping ? -width * 0.3 * (1.0 - dragOffset / width) : -width * 0.3
                        }
                        return -width * 0.3
                    }()

                    let currentOpacity: CGFloat = {
                        if isTopRoute { return 1.0 }
                        if isPreviousRoute { return max(0.75, min(1.0, 0.75 + 0.25 * currentProgress)) }
                        return 0.75
                    }()

                    content(route)
                        .background(Theme.colors.background.ignoresSafeArea())
                        .modifier(PushedScreenModifier(
                            isTop: isTopRoute,
                            opacity: currentOpacity,
                            offset: currentOffset,
                            progress: currentProgress,
                            cornerRadius: maxRadius
                        ))
                        .opacity(isRendered ? 1.0 : 0.0)
                        .allowsHitTesting(isInteractive && isTopRoute && isRendered)
                        .transition(.screenPush(width: width, cornerRadius: maxRadius))
                        .zIndex(Double(index + 2))
                }
            }
            .overlay(
                Group {
                    if isInteractive && hasPushedRoute {
                        EdgeSwipeGestureView(
                            dragOffset: $dragOffset,
                            isSwiping: $isSwiping,
                            screenWidth: width,
                            onPop: onPop
                        )
                        .frame(width: 20)
                    }
                },
                alignment: .leading
            )
        }
    }
}
