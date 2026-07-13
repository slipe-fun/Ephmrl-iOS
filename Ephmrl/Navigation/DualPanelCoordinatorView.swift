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
    @Environment(\.customSafeArea) private var safeArea

    private let indicatorHeight: CGFloat = 30
    private let dividerCornerRadius: CGFloat = 44
    private let peekExtraPadding: CGFloat = 8

    @State private var dragTranslation: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var currentSnapZone: CGFloat = -1
    
    @State private var hapticGenerator = UISelectionFeedbackGenerator()

    var body: some View {
        GeometryReader { proxy in
            let totalHeight = proxy.size.height

            let collapsedHeight = safeArea.top + peekExtraPadding
            let expandedHeight = max(0, totalHeight - indicatorHeight - collapsedHeight)
            let dragRange = max(1, expandedHeight - collapsedHeight)
            let outerRadius = safeArea.top > 20 ? safeArea.top - 6 : 0.0

            let settledProgress: CGFloat = {
                switch router.focus {
                case .main: return 0.0
                case .quarter: return 0.25
                case .half: return 0.5
                case .threeQuarters: return 0.75
                case .compose: return 1.0
                }
            }()
            
            let liveProgress: CGFloat = isDragging
                ? min(1, max(0, settledProgress - dragTranslation / dragRange))
                : settledProgress
            
            let mainContentOpacity: CGFloat = {
                if liveProgress <= 0.5 {
                    return 1.0
                } else {
                    let t = (liveProgress - 0.5) / 0.5
                    return 1.0 - t * 0.5
                }
            }()

            let composeContentOpacity: CGFloat = {
                if liveProgress >= 0.5 {
                    return 1.0
                } else {
                    let t = liveProgress / 0.5
                    return 0.5 + t * 0.5
                }
            }()

            let yOffset = -dragRange * liveProgress
            let sheetsAreIdle = bottomSheetManager.state == .hidden

            VStack(spacing: 0) {
                StackContainerView(
                    path: router.mainPath,
                    isInteractive: router.focus == .main && !isDragging && sheetsAreIdle,
                    onPop: { router.popMain(animated: false) },
                    root: {
                        WelcomeScreen()
                            .opacity(mainContentOpacity)
                    },
                    content: { route in
                        switch route {
                        case .feed, .profile, .article:
                            WelcomeScreen()
                                .opacity(mainContentOpacity)
                        }
                    }
                )
                .frame(height: expandedHeight)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: outerRadius,
                        bottomLeadingRadius: dividerCornerRadius,
                        bottomTrailingRadius: dividerCornerRadius,
                        topTrailingRadius: outerRadius
                    )
                )
                .zIndex(0)

                SnapIndicatorView(
                    dragTranslation: $dragTranslation,
                    isDragging: $isDragging,
                    onEnded: { finalTranslation, velocity in
                        let currentProgress = settledProgress - (finalTranslation / dragRange)
                        let momentum = (velocity / dragRange) * 0.25
                        let projectedProgress = currentProgress - momentum
                        
                        let snapPoints: [CGFloat] = [0.0, 0.25, 0.5, 0.75, 1.0]
                        let closest = snapPoints.min(by: { abs($0 - projectedProgress) < abs($1 - projectedProgress) }) ?? 0.0
                        
                        let newFocus: PanelFocus
                        switch closest {
                        case 0.0: newFocus = .main
                        case 0.25: newFocus = .quarter
                        case 0.5: newFocus = .half
                        case 0.75: newFocus = .threeQuarters
                        default: newFocus = .compose
                        }
                        
                        let targetValue: CGFloat = closest
                        
                        if targetValue != currentSnapZone {
                            hapticGenerator.selectionChanged()
                        }
                        
                        withAnimation(.smooth(duration: 0.4, extraBounce: 0.14)) {
                            isDragging = false
                            dragTranslation = 0
                            router.setFocus(newFocus, animated: false)
                        }
                    }
                )
                .frame(height: indicatorHeight)
                .allowsHitTesting(sheetsAreIdle)
                .zIndex(1)

                StackContainerView(
                    path: router.composePath,
                    isInteractive: router.focus == .compose && !isDragging && sheetsAreIdle,
                    onPop: { router.popCompose(animated: false) },
                    root: {
                        WelcomeScreen()
                            .opacity(composeContentOpacity)
                    },
                    content: { route in
                        switch route {
                        case .articleCreate:
                            WelcomeScreen()
                                .opacity(composeContentOpacity)
                        }
                    }
                )
                .frame(height: expandedHeight)
                .background(Theme.colors.background)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: dividerCornerRadius,
                        bottomLeadingRadius: outerRadius,
                        bottomTrailingRadius: outerRadius,
                        topTrailingRadius: dividerCornerRadius
                    )
                )
                .zIndex(0)
            }
            .frame(width: proxy.size.width, height: totalHeight, alignment: .top)
            .offset(y: yOffset)
            .onChange(of: isDragging) { _, dragging in
                if dragging {
                    hapticGenerator.prepare()
                    let snapPoints: [CGFloat] = [0.0, 0.25, 0.5, 0.75, 1.0]
                    currentSnapZone = snapPoints.min(by: { abs($0 - liveProgress) < abs($1 - liveProgress) }) ?? 0.0
                }
            }
            .onChange(of: dragTranslation) { _, newValue in
                guard isDragging else { return }
                
                let currentLiveProgress = min(1, max(0, settledProgress - newValue / dragRange))
                let snapPoints: [CGFloat] = [0.0, 0.25, 0.5, 0.75, 1.0]
                let closest = snapPoints.min(by: { abs($0 - currentLiveProgress) < abs($1 - currentLiveProgress) }) ?? 0.0
                
                if closest != currentSnapZone {
                    currentSnapZone = closest
                    hapticGenerator.selectionChanged()
                    hapticGenerator.prepare()
                }
            }
        }
    }
}
