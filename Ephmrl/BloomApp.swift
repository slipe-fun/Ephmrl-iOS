//
//  BloomApp.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

@main
struct BloomApp: App {
    @State private var bottomSheetManager = BottomSheetManager()
    @State private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .environment(bottomSheetManager)
                .environment(router)
        }
    }
}
