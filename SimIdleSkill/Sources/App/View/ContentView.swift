//
//  ContentView.swift
//  SimIdleApp
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI
import SimIdleExperience

public struct ContentView: View {
    @StateObject private var history = History<SimIdleSkill>()
    @State private var store: [String: String] = [:]
    private let registry = DefaultSkillRegistry()
    
    public init() {}
    
    public var body: some View {
        content
            .animation(.easeInOut(duration: 0.3), value: history.current)
    }
    
    @ViewBuilder
    private var content: some View {
        let currentSkill = history.current ?? .experience
        if let view = registry.buildView(
            for: currentSkill,
            store: store,
            onStoreUpdate: { key, value in
                store[key] = value
            },
            onNavigate: { skillId in
                guard let skill = SimIdleSkill.from(id: skillId) else { return }
                history.push(skill)
            },
            onBack: {
                history.pop()
            }
        ) {
            view.transition(.opacity)
        }
    }
}

#Preview {
    ContentView()
}
