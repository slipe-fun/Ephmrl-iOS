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

    private let minPanelOpacity: CGFloat = 0.3

    private let indicatorHeight: CGFloat = 30
    private let dividerCornerRadius: CGFloat = 44

    private static let snapPoints: [CGFloat] = [0.0, 0.25, 0.5, 0.75, 1.0]
    private static let springStiffness: Double = 250
    private static let springDamping: Double = 26

    @State private var dragTranslation: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var currentSnapZone: CGFloat = -1
    @State private var releaseVelocity: Double = 0

    private let hapticGenerator = UISelectionFeedbackGenerator()

    var body: some View {
        GeometryReader { proxy in
            let totalHeight = proxy.size.height
            let collapsedHeight = safeArea.top - 4 + dividerCornerRadius
            let expandedHeight = max(0, totalHeight - indicatorHeight - collapsedHeight)
            let dragRange = max(1, expandedHeight - collapsedHeight)
            let outerRadius = safeArea.top > 20 ? safeArea.top - 4 : 0.0

            let settledProgress: CGFloat = switch router.focus {
                case .main: 0.0
                case .quarter: 0.25
                case .half: 0.5
                case .threeQuarters: 0.75
                case .compose: 1.0
            }

            let liveProgress = isDragging
                ? min(1, max(0, settledProgress - dragTranslation / dragRange))
                : settledProgress

            let opacityDelta = 1.0 - minPanelOpacity
            let mainOpacity = liveProgress <= 0.5 ? 1.0 : 1.0 - ((liveProgress - 0.5) / 0.5) * opacityDelta
            let composeOpacity = liveProgress >= 0.5 ? 1.0 : minPanelOpacity + (liveProgress / 0.5) * opacityDelta

            let mainVisibleHeight = max(0, expandedHeight - dragRange * liveProgress)
            let composeVisibleHeight = max(0, collapsedHeight + dragRange * liveProgress)
            let sheetsAreIdle = bottomSheetManager.state == .hidden

            let snapSpring = Animation.interpolatingSpring(
                mass: 0.8, stiffness: Self.springStiffness, damping: Self.springDamping, initialVelocity: releaseVelocity
            )
            let tapSpring = Animation.interpolatingSpring(
                mass: 0.8, stiffness: Self.springStiffness, damping: Self.springDamping, initialVelocity: 0
            )

            VStack(spacing: 0) {
                StackContainerView(
                    path: router.mainPath,
                    isInteractive: router.focus == .main && !isDragging && sheetsAreIdle,
                    onPop: { router.popMain(animated: false) },
                    root: { WelcomeScreen().opacity(mainOpacity) },
                    content: { route in
                        Group {
                            switch route {
                            case .feed, .profile, .article:
                                WelcomeScreen()
                            }
                        }
                        .opacity(mainOpacity)
                    }
                )
                .frame(height: mainVisibleHeight)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: outerRadius, bottomLeadingRadius: dividerCornerRadius, bottomTrailingRadius: dividerCornerRadius, topTrailingRadius: outerRadius))
                .overlay {
                    if router.focus == .compose {
                        Color.clear.contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(tapSpring) {
                                    releaseVelocity = 0
                                    router.setFocus(.main, animated: false)
                                }
                            }
                    }
                }
                .zIndex(0)

                SnapIndicatorView(
                    dragTranslation: $dragTranslation,
                    isDragging: $isDragging,
                    onEnded: { finalTranslation, predictedTranslation, velocity in
                        let currentProgress = settledProgress - finalTranslation / dragRange
                        let targetProgress = settledProgress - (predictedTranslation / dragRange)
                        let closest = Self.snapPoints.min(by: { abs($0 - targetProgress) < abs($1 - targetProgress) }) ?? 0.0
                        let heightDelta = -dragRange * (closest - currentProgress)

                        releaseVelocity = max(-30, min(30, abs(heightDelta) > 1 ? Double(velocity / heightDelta) : 0))

                        let newFocus: PanelFocus = switch closest {
                            case 0.0: .main
                            case 0.25: .quarter
                            case 0.5: .half
                            case 0.75: .threeQuarters
                            default: .compose
                        }

                        if closest != currentSnapZone { hapticGenerator.selectionChanged() }

                        withAnimation(snapSpring) {
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
                    root: { WelcomeScreen().opacity(composeOpacity) },
                    content: { route in
                        Group {
                            switch route {
                            case .articleCreate:
                                WelcomeScreen()
                            }
                        }
                        .opacity(composeOpacity)
                    }
                )
                .frame(height: composeVisibleHeight)
                .background(Theme.colors.background)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: dividerCornerRadius, bottomLeadingRadius: outerRadius, bottomTrailingRadius: outerRadius, topTrailingRadius: dividerCornerRadius))
                .overlay {
                    if router.focus == .main {
                        Color.clear.contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(tapSpring) {
                                    releaseVelocity = 0
                                    router.setFocus(.compose, animated: false)
                                }
                            }
                    }
                }
                .zIndex(0)
            }
            .frame(width: proxy.size.width, height: totalHeight, alignment: .top)
            .animation(isDragging ? nil : snapSpring, value: liveProgress)
            .onChange(of: isDragging) { _, dragging in
                if dragging {
                    hapticGenerator.prepare()
                    currentSnapZone = Self.snapPoints.min(by: { abs($0 - liveProgress) < abs($1 - liveProgress) }) ?? 0.0
                }
            }
            .onChange(of: dragTranslation) { _, newValue in
                guard isDragging else { return }
                let currentLiveProgress = min(1, max(0, settledProgress - newValue / dragRange))
                let closest = Self.snapPoints.min(by: { abs($0 - currentLiveProgress) < abs($1 - currentLiveProgress) }) ?? 0.0

                if closest != currentSnapZone {
                    currentSnapZone = closest
                    hapticGenerator.selectionChanged()
                    hapticGenerator.prepare()
                }
            }
        }
    }
}
