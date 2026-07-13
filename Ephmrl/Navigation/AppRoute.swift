//
//  AppRoute.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI

enum AppRoute: Hashable {
    case welcome
    case chats
    case chatDetail(chatId: Int)
    case settings
}
