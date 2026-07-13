//
//  AppRouter.swift
//  Ephmrl
//
//  Created by Аскольд on 13.07.2026.
//

import SwiftUI
import Observation

@Observable
@MainActor
class AppRouter {
    var path: [AppRoute] = []
    
    var isAuthenticated: Bool {
        didSet {
            UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
        }
    }
    
    init() {
        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        
        Task {
            _ = HapticManager.shared
        }
    }
    
    
    var standardPath: [AppRoute] {
        path
    }
    
    func setAuthenticated(_ authenticated: Bool) {
        withAnimation(.quickSpring) {
            self.isAuthenticated = authenticated
            if !authenticated {
                self.path.removeAll()
            }
        }
    }
    
    func push(_ route: AppRoute) {
        withAnimation(.normalSpring) {
            path.append(route)
        }
    }
    
    func pop(animated: Bool = true) {
        if animated {
            withAnimation(.normalSpring) {
                if !path.isEmpty {
                    path.removeLast()
                }
            }
        } else {
            if !path.isEmpty {
                path.removeLast()
            }
        }
    }
    
    func popToRoot() {
        withAnimation(.normalSpring) {
            path.removeAll()
        }
    }
}
