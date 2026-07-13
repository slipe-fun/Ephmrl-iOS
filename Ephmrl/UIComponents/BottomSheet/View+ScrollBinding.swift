//
//  View+ScrollBinding.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

extension View {
    func bindBottomSheetScrollOffset(to manager: BottomSheetManager) -> some View {
        self.onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentOffset.y
        } action: { oldValue, newValue in
            manager.scrollOffset = newValue
        }
    }
}
