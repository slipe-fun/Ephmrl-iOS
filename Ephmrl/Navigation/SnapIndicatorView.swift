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
    let onEnded: (_ finalTranslation: CGFloat, _ predictedTranslation: CGFloat, _ velocity: CGFloat) -> Void

    var body: some View {
        ZStack {
            Color.clear
                .frame(height: 55)
                .contentShape(Rectangle())

            Capsule()
                .fill(Theme.colors.secondaryText)
                .frame(width: 50, height: 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged { value in
                    isDragging = true
                    dragTranslation = value.translation.height
                }
                .onEnded { value in
                    onEnded(
                        value.translation.height,
                        value.predictedEndTranslation.height,
                        value.velocity.height
                    )
                }
        )
    }
}
