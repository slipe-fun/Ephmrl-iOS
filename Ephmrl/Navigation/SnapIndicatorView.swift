//
//  SnapIndicatorView.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

struct SnapIndicatorView: View {
    @Binding var dragTranslation: CGFloat
    @Binding var isDragging: Bool
    let onEnded: (_ finalTranslation: CGFloat) -> Void

    var body: some View {
        Capsule()
            .fill(Theme.colors.secondaryText)
            .frame(width: 40, height: 5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        dragTranslation = value.translation.height
                    }
                    .onEnded { value in
                        onEnded(value.translation.height)
                    }
            )
    }
}
