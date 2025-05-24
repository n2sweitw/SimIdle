//
//  DefaultSkillRegistry.swift
//  SimIdleApp
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI
import SimIdleExperience
import SimIdleShare

struct DefaultSkillRegistry: SkillRegistry {
    typealias SkillType = SimIdleSkill
    
    let supportedSkillIds: [String] = [
        ExperienceSkillView.skillId,
        ShareSkillView.skillId
    ]
    
    init() {
        validateSkillConsistency()
    }
    
    func buildView(
        for skill: SkillType,
        store: [String: String],
        onStoreUpdate: @escaping (String, String) -> Void,
        onNavigate: @escaping (String) -> Void,
        onBack: @escaping () -> Void
    ) -> AnyView? {
        switch skill {
        case .experience:
            return AnyView(
                ExperienceSkillView(store: store)
                    .configureNavigation(
                        onStoreUpdate: onStoreUpdate,
                        onNavigate: onNavigate,
                        onBack: onBack
                    )
            )
        case .share:
            return AnyView(
                ShareSkillView(store: store)
                    .configureNavigation(
                        onStoreUpdate: onStoreUpdate,
                        onNavigate: onNavigate,
                        onBack: onBack
                    )
            )
        }
    }
}
