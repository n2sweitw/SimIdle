//
//  SkillRegistory.swift
//  SimIdleSkill
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

// MARK: - Skill Protocol Definition

/// Represents a navigatable skill in the application
public protocol Skill: Hashable, CaseIterable {
    /// Unique identifier for the skill
    var id: String { get }
    
    /// Create skill from string identifier
    static func from(id: String) -> Self?
}

// MARK: - Skill View Protocol

/// Protocol for views that can be presented as skill content
public protocol SkillView: View {
    /// The skill this view represents
    static var skillId: String { get }
    
    /// Initialize view with store dictionary
    init(store: [String: String])
    
    /// Configure view with navigation callbacks
    func configureNavigation(
        onStoreUpdate: @escaping (String, String) -> Void,
        onNavigate: @escaping (String) -> Void,
        onBack: @escaping () -> Void
    ) -> Self
}

// MARK: - Skill Registry

/// Registry for mapping skills to their corresponding views
@MainActor
public protocol SkillRegistry {
    associatedtype SkillType: Skill
    
    /// Supported skill IDs that this registry can handle
    var supportedSkillIds: [String] { get }
    
    /// Build view for the given skill
    func buildView(
        for skill: SkillType,
        store: [String: String],
        onStoreUpdate: @escaping (String, String) -> Void,
        onNavigate: @escaping (String) -> Void,
        onBack: @escaping () -> Void
    ) -> AnyView?
}

// MARK: - Skill Registry Default Implementation

public extension SkillRegistry {
    /// Verify that all SkillType cases have corresponding implementations
    func validateSkillConsistency() {
        let enumSkillIds = Set(SkillType.allCases.map { $0.id })
        let registrySkillIds = Set(supportedSkillIds)
        
        assert(
            enumSkillIds == registrySkillIds,
            "Mismatch between \(SkillType.self) cases and SkillRegistry implementations. " +
            "Enum skills: \(enumSkillIds), Registry skills: \(registrySkillIds)"
        )
    }
}
