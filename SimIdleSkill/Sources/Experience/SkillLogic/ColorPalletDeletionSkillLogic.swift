//
//  ColorPalletDeletionSkillLogic.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Foundation

/// Manages color palette deletion workflow and business logic
struct ColorPalletDeletionSkillLogic {
    let colorStore: ColorStore
    
    init(colorStore: ColorStore) {
        self.colorStore = colorStore
    }
    
    /// Determines the appropriate action for color palette deletion events
    func determineAction(for event: ColorPalletDeletionEvent) -> ColorPalletDeletionAction {
        switch event {
        case .longTap(let index):
            return .requestDeleteConfirmation(index: index)
        case .deleteConfirmed(let index):
            return .delete(index: index)
        case .deleteCancel:
            return .cancelDelete
        }
    }
    
    /// Executes the color palette deletion action
    func executeAction(_ action: ColorPalletDeletionAction) -> ColorPalletDeletionResult {
        switch action {
        case .requestDeleteConfirmation(let index):
            guard index < colorStore.colorPallets.count else {
                return .failure(.invalidIndex)
            }
            return .success(.deleteConfirmationRequested(index: index))
            
        case .delete(let index):
            guard index < colorStore.colorPallets.count else {
                return .failure(.invalidIndex)
            }
            let palletCount = colorStore.colorPallets.count
            colorStore.removePallet(at: index)
            return .success(.deleted(remainingCount: palletCount - 1))
            
        case .cancelDelete:
            return .success(.deleteCancelled)
        }
    }
}

enum ColorPalletDeletionEvent: Equatable {
    case longTap(index: Int)
    case deleteConfirmed(index: Int)
    case deleteCancel
}

enum ColorPalletDeletionAction: Equatable {
    case requestDeleteConfirmation(index: Int)
    case delete(index: Int)
    case cancelDelete
}

enum ColorPalletDeletionResult: Equatable {
    case success(ColorPalletDeletionResultType)
    case failure(ColorPalletDeletionError)
}

enum ColorPalletDeletionResultType: Equatable {
    case deleteConfirmationRequested(index: Int)
    case deleted(remainingCount: Int)
    case deleteCancelled
}

enum ColorPalletDeletionError: Equatable {
    case invalidIndex
    case emptyPallet
}
