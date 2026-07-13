//
//  EnviromentValues+SafeArea.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

struct CustomSafeAreaKey: EnvironmentKey {
    static var defaultValue: EdgeInsets = EdgeInsets()
}

extension EnvironmentValues {
    var customSafeArea: EdgeInsets {
        get { self[CustomSafeAreaKey.self] }
        set { self[CustomSafeAreaKey.self] = newValue }
    }
}
