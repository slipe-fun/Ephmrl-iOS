//
//  DragHandleView.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

struct DragHandleView: View {
    var body: some View {
        ZStack {
            Capsule()
                .fill(Theme.colors.secondaryText)
                .frame(width: 32, height: 4)
                .padding(.top, 6)
                .padding(.bottom, 6)
                .contentShape(Rectangle())
        }
    }
}
