//
//  EnviromentValues+Custom.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

struct CustomSafeAreaKey: EnvironmentKey {
    static var defaultValue: EdgeInsets = EdgeInsets()
}

struct CustomScreenKey: EnvironmentKey {
    static var defaultValue: CGSize = CGSize(width: 0, height: 0)
}

extension EnvironmentValues {
    var customSafeArea: EdgeInsets {
        get { self[CustomSafeAreaKey.self] }
        set { self[CustomSafeAreaKey.self] = newValue }
    }
    
    var customScreen: CGSize {
        get { self[CustomScreenKey.self] }
        set { self[CustomScreenKey.self] = newValue }
    }
}
