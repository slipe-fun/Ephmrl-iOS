//
//  WelcomeFooterView.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

struct WelcomeFooterView: View {
    @Environment(AppRouter.self) private var router
    @State private var isAppeared = false
    
    var body: some View {
        GlassEffectContainer{
            VStack(alignment: .trailing, spacing: Theme.spacing.md) {
                Button {
                    print("swag")
                } label: {
                    HStack(spacing: Theme.spacing.sm) {
                        CustomLottieView(
                            source: "faceId",
                            loop: true,
                            autoPlay: true,
                            size: 26,
                            color: Theme.colors.white
                        )
                        Text("Continue with FaceID")
                            .font(Theme.font.button)
                            .foregroundStyle(Theme.colors.white)
                    }
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .glassEffect(.regular.interactive().tint(Theme.colors.primary))
                
                Text("By continuing you agree to the **[Terms of Service](custom-scheme//terms)**")
                    .font(Theme.font.body)
                    .foregroundStyle(Theme.colors.secondaryText)
                    .tint(Theme.colors.primary)
                    .environment(\.openURL, OpenURLAction { url in
                        if url.scheme == "custom-scheme" {
                            print("Terms opened!")
                            return .handled
                        }
                        return .systemAction
                    })
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
        }
        .opacity(isAppeared ? 1.0 : 0.0)
        .offset(y: isAppeared ? 0 : 40)
        .padding(.horizontal, Theme.spacing.xxxl + 8)
        .padding(.bottom, Theme.spacing.xxxl + 8)
        .onAppear {
            withAnimation(.smooth(duration: 0.6)) {
                isAppeared = true
            }
        }
    }
}
