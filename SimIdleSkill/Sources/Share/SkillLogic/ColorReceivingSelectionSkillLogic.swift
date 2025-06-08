//
//  ColorReceivingSelectionSkillLogic.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Foundation

/// Manages color selection movement logic between palette and candidates
/// 
/// This SkillLogic encapsulates the decision-making process for moving colors
/// between the palette and candidates, specifically preventing movement of
/// colors that are part of the initial available elements.
struct ColorReceivingSelectionSkillLogic {
    
    init() {}
    
    /// Determines if a color element can be moved from palette to candidates
    /// - Parameters:
    ///   - element: The color element to check
    ///   - availableElements: The initial available elements (protected from movement)
    /// - Returns: true if the element can be moved, false otherwise
    func canMovePaletteElement(
        _ element: ColorElement,
        availableElements: [ColorElement]
    ) -> Bool {
        // Check if the element is one of the initial available elements
        !availableElements.contains(where: { $0.colorCode == element.colorCode })
    }
    
    /// Validates a movement request from palette to candidates
    /// - Parameters:
    ///   - index: The index of the element in the palette
    ///   - palette: The current palette of elements
    ///   - availableElements: The initial available elements
    /// - Returns: A movement validation result
    func validatePaletteMovement(
        at index: Int,
        palette: [ColorElement],
        availableElements: [ColorElement]
    ) -> MovementValidationResult {
        // Check index bounds
        guard index >= 0 && index < palette.count else {
            return .invalid(reason: .indexOutOfBounds)
        }
        
        let element = palette[index]
        
        // Check if movement is allowed
        if canMovePaletteElement(element, availableElements: availableElements) {
            return .valid(element: element)
        } else {
            return .invalid(reason: .protectedElement)
        }
    }
}

enum MovementValidationResult: Equatable {
    case valid(element: ColorElement)
    case invalid(reason: MovementInvalidReason)
}

enum MovementInvalidReason: Equatable {
    case indexOutOfBounds
    case protectedElement
}