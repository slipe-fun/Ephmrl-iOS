//
//  PhotoPressButtonStyle.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

struct PhotoPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        
        configuration.label
            .scaleEffect(isPressed ? 0.925 : 1.0)
            .zIndex(isPressed ? 1 : 0)
            .animation(.springy, value: isPressed)
    }
}
