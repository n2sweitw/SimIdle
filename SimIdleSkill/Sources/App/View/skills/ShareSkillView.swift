//
//  ShareSkillView.swift
//  SimIdleApp
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI
import SimIdleShare

public struct ShareSkillView: SkillView {
    public static let skillId: String = "share"
    
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
        ShareView(colorElementSet: store["colorElementSet"] ?? "")
            .onColorElementSetUpdate { newColorElementSet in
                self.onStoreUpdate?("colorElementSet", newColorElementSet)
            }
            .onComplete {
                self.onBack?()
            }
    }
}

#Preview {
    ShareSkillView(store: [:])
}
