//
//  WelcomeScreen.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI
import BlurSwiftUI

struct WelcomeScreen: View {
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        VStack(alignment: .trailing) {
            WelcomeFooterView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.colors.background)
    }
}
