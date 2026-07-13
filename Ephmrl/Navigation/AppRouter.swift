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
    
    var isAuthenticated: Bool {
        didSet {
            UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
        }
    }
    
    var mainPath: [MainRoute] = []
    var composePath: [ComposeRoute] = []
    
    var focus: PanelFocus = .main
    
    init() {
        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        
        Task {
            _ = HapticManager.shared
        }
    }
    
    func setAuthenticated(_ authenticated: Bool) {
        withAnimation(.quickSpring) {
            self.isAuthenticated = authenticated
            if !authenticated {
                self.mainPath.removeAll()
                self.composePath.removeAll()
                self.focus = .main
            }
        }
    }
    
    func pushMain(_ route: MainRoute) {
        withAnimation(.normalSpring) {
            mainPath.append(route)
        }
    }
    
    func popMain(animated: Bool = true) {
        guard !mainPath.isEmpty else { return }
        if animated {
            withAnimation(.normalSpring) { mainPath.removeLast() }
        } else {
            mainPath.removeLast()
        }
    }
    
    func popMainToRoot() {
        withAnimation(.normalSpring) { mainPath.removeAll() }
    }
    
    
    func pushCompose(_ route: ComposeRoute) {
        withAnimation(.normalSpring) {
            composePath.append(route)
        }
    }
    
    func popCompose(animated: Bool = true) {
        guard !composePath.isEmpty else { return }
        if animated {
            withAnimation(.normalSpring) { composePath.removeLast() }
        } else {
            composePath.removeLast()
        }
    }
    
    func popComposeToRoot() {
        withAnimation(.normalSpring) { composePath.removeAll() }
    }
    
    func setFocus(_ newFocus: PanelFocus, animated: Bool = true) {
        if animated {
            withAnimation(.normalSpring) { focus = newFocus }
        } else {
            focus = newFocus
        }
    }
    
    func toggleFocus() {
        setFocus(focus == .main ? .compose : .main)
    }
}
