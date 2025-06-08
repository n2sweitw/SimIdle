//
//  ColorSelectionState.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Foundation

/// Data state for color palette selection management
struct ColorReceivingSelectionState: Equatable {
    let availableElements: [ColorElement]
    let colorCandidates: [ColorElement]
    let colorPalette: [ColorElement]
    
    init(availableElements: [ColorElement], colorCandidates: [ColorElement] = []) {
        self.availableElements = availableElements
        self.colorCandidates = colorCandidates
        self.colorPalette = availableElements
    }
    
    private init(
        availableElements: [ColorElement],
        colorCandidates: [ColorElement],
        colorPalette: [ColorElement]
    ) {
        self.availableElements = availableElements
        self.colorCandidates = colorCandidates
        self.colorPalette = colorPalette
    }
    
    /// Updates with color candidates, filtering out duplicates and limiting to 5
    func with(colorCandidates elements: [ColorElement]) -> ColorReceivingSelectionState {
        let paletteCodes = Set(colorPalette.map { $0.colorCode })
        let filteredElements = elements.filter { !paletteCodes.contains($0.colorCode) }
        // Limit color candidates to 5
        let limitedElements = Array(filteredElements.prefix(5))
        
        return ColorReceivingSelectionState(
            availableElements: availableElements,
            colorCandidates: limitedElements,
            colorPalette: colorPalette
        )
    }
    
    /// Clears color candidates
    func clearCandidates() -> ColorReceivingSelectionState {
        ColorReceivingSelectionState(
            availableElements: availableElements,
            colorCandidates: [],
            colorPalette: colorPalette
        )
    }
    
    /// Moves element from candidates to palette
    func moveCandidateToPalette(at index: Int) -> ColorReceivingSelectionState {
        guard colorPalette.count < 5, index < colorCandidates.count else { return self }
        
        var newCandidates = colorCandidates
        var newPalette = colorPalette
        
        let element = newCandidates.remove(at: index)
        newPalette.append(element)
        
        return ColorReceivingSelectionState(
            availableElements: availableElements,
            colorCandidates: newCandidates,
            colorPalette: newPalette
        )
    }
    
    /// Moves element from palette to candidates
    func movePaletteToCandidate(at index: Int) -> ColorReceivingSelectionState {
        guard colorCandidates.count < 6, index < colorPalette.count else { return self }
        
        var newCandidates = colorCandidates
        var newPalette = colorPalette
        
        let element = newPalette.remove(at: index)
        newCandidates.append(element)
        
        return ColorReceivingSelectionState(
            availableElements: availableElements,
            colorCandidates: newCandidates,
            colorPalette: newPalette
        )
    }
    
    /// Resets to initial state
    func reset() -> ColorReceivingSelectionState {
        ColorReceivingSelectionState(availableElements: availableElements)
    }
}
