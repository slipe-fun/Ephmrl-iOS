//
//  AppRoute.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//
import SwiftUI

enum MainRoute: Hashable {
    case feed
    case profile
    case article(id: String)
}

enum ComposeRoute: Hashable {
    case articleCreate
}
