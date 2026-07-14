//
//  AppCoordinatorView.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

struct AppCoordinatorView: View {
    @Environment(AppRouter.self) private var router
    @Environment(BottomSheetManager.self) private var bottomSheetManager

    @State private var bottomSheetZIndex: Double = 200

    var body: some View {
        GeometryReader { proxy in
            let safeArea = proxy.safeAreaInsets
            let screen = proxy.size
            
            ZStack {
                Theme.colors.grayBackground.ignoresSafeArea()

                Group {
                    if router.isAuthenticated {
                        DualPanelCoordinatorView()
                            .environment(router)
                    } else {
                        WelcomeScreen()
                            .environment(router)
                    }
                }
                .transition(.opacity)
                .zIndex(1)

                GlobalBottomSheetOverlayView()
                    .zIndex(bottomSheetZIndex)
            }
            .ignoresSafeArea()
            .environment(\.customSafeArea, safeArea)
            .environment(\.customScreen, screen)
            .onChange(of: bottomSheetManager.state) { oldValue, newValue in
                if oldValue == .hidden && newValue != .hidden {
                    let topPathCount = router.focus == .main ? router.mainPath.count : router.composePath.count
                    bottomSheetZIndex = Double(topPathCount) + 1.5
                }
            }
        }
    }
}
