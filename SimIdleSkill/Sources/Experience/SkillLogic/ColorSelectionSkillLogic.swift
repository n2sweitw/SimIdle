//
// ColorSelectionSkillLogic.swift
// SimIdleExperience
//
// Copyright (c) 2025 Tadashi Kimura
// SPDX-License-Identifier: MIT
// Generated with support from Claude Code (Anthropic)
//

import Foundation

/// Handles color selection skill logic and business rules
struct ColorSelectionSkillLogic {
    let colorStore: ColorStore
    
    init(colorStore: ColorStore) {
        self.colorStore = colorStore
    }
    
    /// Determines the appropriate action based on current state
    func determineAction(for session: ColorEditingSession) -> ColorSelectionAction {
        let hasChanges = session.hasChanges(comparedTo: colorStore)
        
        if !hasChanges {
            return .back
        }
        
        if colorStore.colorPallets.count < colorStore.maxPallets {
            return .add
        } else {
            return .apply
        }
    }
    
    /// Executes the color selection action
    func executeAction(_ action: ColorSelectionAction, with session: ColorEditingSession) -> ColorSelectionResult {
        let element = session.createElement()
        
        switch action {
        case .add:
            if !colorStore.hasMatchingPallet(element: element) {
                colorStore.addColorsToPallet(element: element)
                return .success(.added)
            } else {
                return .success(.alreadyExists)
            }
            
        case .apply:
            colorStore.updateCurrentColors(element: element)
            return .success(.applied)
            
        case .reset:
            session.resetAll()
            return .success(.reset)
            
        case .back:
            return .success(.navigatedBack)
        }
    }
}

enum ColorSelectionAction {
    case add
    case apply
    case reset
    case back
}

enum ColorSelectionResult {
    case success(ColorSelectionResultType)
    case failure(ColorSelectionError)
}

enum ColorSelectionResultType {
    case added
    case applied
    case reset
    case navigatedBack
    case alreadyExists
}

enum ColorSelectionError {
    case invalidState
    case storageError
}
