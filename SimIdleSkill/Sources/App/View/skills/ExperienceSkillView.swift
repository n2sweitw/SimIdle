//
//  ExperienceSkillView.swift
//  SimIdleApp
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI
import SimIdleExperience

public struct ExperienceSkillView: SkillView {
    public static let skillId: String = "experience"
    
    private let store: [String: String]
    private var onStoreUpdate: ((String, String) -> Void)?
    private var onNavigate: ((String) -> Void)?
    private var onBack: (() -> Void)?
    
    public init(store: [String: String]) {
        self.store = store
    }
    
    public func configureNavigation(
        onStoreUpdate: @escaping (String, String) -> Void,
        onNavigate: @escaping (String) -> Void,
        onBack: @escaping () -> Void
    ) -> Self {
        var view = self
        view.onStoreUpdate = onStoreUpdate
        view.onNavigate = onNavigate
        view.onBack = onBack
        return view
    }
    
    public var body: some View {
        ExperienceView(colorElementSet: store["colorElementSet"] ?? "")
            .onColorUpdate { colorElementSet in
                self.onStoreUpdate?("colorElementSet", colorElementSet)
            }
            .onBackgroundTap {
                self.onNavigate?("share")
            }
    }
}
