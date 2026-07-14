//
//  EphmrlApp.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI
import Nuke

@main
struct EphmrlApp: App {
    @State private var bottomSheetManager = BottomSheetManager()
    @State private var router = AppRouter()
    
    init() {
        if let dataCache = try? DataCache(name: "org.ephmrl.datacache") {
            var config = ImagePipeline.Configuration.withDataCache
            config.dataCache = dataCache
            ImagePipeline.shared = ImagePipeline(configuration: config)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .environment(bottomSheetManager)
                .environment(router)
        }
    }
}
