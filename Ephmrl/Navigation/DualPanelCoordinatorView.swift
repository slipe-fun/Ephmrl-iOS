//
//  DualPanelCoordinatorView.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

struct DualPanelCoordinatorView: View {
    @Environment(AppRouter.self) private var router
    @Environment(BottomSheetManager.self) private var bottomSheetManager
    @Environment(\.customSafeArea.self) private var safeArea

    private let indicatorHeight: CGFloat = 25
    private let dividerCornerRadius: CGFloat = 44
    private let peekExtraPadding: CGFloat = 48

    @State private var dragTranslation: CGFloat = 0
    @State private var isDragging: Bool = false

    var body: some View {
        GeometryReader { proxy in
            let totalHeight = proxy.size.height

            let collapsedHeight = safeArea.top + peekExtraPadding
            let expandedHeight = max(0, totalHeight - indicatorHeight - collapsedHeight)
            let dragRange = max(1, expandedHeight - collapsedHeight)
            let outerRadius = safeArea.top > 20 ? safeArea.top - 4 : 0.0

            let settledProgress: CGFloat = router.focus == .compose ? 1.0 : 0.0
            let liveProgress: CGFloat = isDragging
                ? min(1, max(0, settledProgress - dragTranslation / dragRange))
                : settledProgress

            let mainHeight = expandedHeight - (expandedHeight - collapsedHeight) * liveProgress
            let composeHeight = totalHeight - indicatorHeight - mainHeight
            
            let sheetsAreIdle = bottomSheetManager.state == .hidden

            VStack(spacing: 0) {
                StackContainerView(
                    path: router.mainPath,
                    isInteractive: router.focus == .main && !isDragging && sheetsAreIdle,
                    safeArea: safeArea,
                    onPop: { router.popMain(animated: false) },
                    root: {
                        WelcomeScreen()
                    },
                    content: { route in
                        switch route {
                        case .feed:
                            WelcomeScreen()
                        case .profile:
                            WelcomeScreen()
                        case .article:
                            WelcomeScreen()
                        }
                    }
                )
                .frame(height: mainHeight)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: outerRadius,
                        bottomLeadingRadius: dividerCornerRadius,
                        bottomTrailingRadius: dividerCornerRadius,
                        topTrailingRadius: outerRadius
                    )
                )

                SnapIndicatorView(
                    dragTranslation: $dragTranslation,
                    isDragging: $isDragging,
                    onEnded: { finalTranslation in
                        let newProgress = min(1, max(0, settledProgress - finalTranslation / dragRange))
                        let newFocus: PanelFocus = newProgress > 0.5 ? .compose : .main
                        withAnimation(.normalSpring) {
                            isDragging = false
                            dragTranslation = 0
                            router.setFocus(newFocus, animated: false)
                        }
                    }
                )
                .frame(height: indicatorHeight)
                .allowsHitTesting(sheetsAreIdle)

                StackContainerView(
                    path: router.composePath,
                    isInteractive: router.focus == .compose && !isDragging && sheetsAreIdle,
                    safeArea: safeArea,
                    onPop: { router.popCompose(animated: false) },
                    root: {
                        WelcomeScreen()
                    },
                    content: { route in
                        switch route {
                        case .articleCreate:
                            WelcomeScreen()
                        }
                    }
                )
                .frame(height: composeHeight)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: dividerCornerRadius,
                        bottomLeadingRadius: outerRadius,
                        bottomTrailingRadius: outerRadius,
                        topTrailingRadius: dividerCornerRadius
                    )
                )
            }
            .environment(router)
            .environment(\.customSafeArea, safeArea)
            .ignoresSafeArea()
        }
    }
}
