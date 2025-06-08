//
//  ColorReceivingSelectionSkillLogicTests.swift
//  SimIdleShareTests
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Testing
@testable import SimIdleShare

@Suite
struct ColorReceivingSelectionSkillLogicTests {
    
    let logic = ColorReceivingSelectionSkillLogic()
    
    // Test data
    let initialElement1 = ColorElement(orbHexCode: "#4A4A4A", spaceHexCode: "#F8F8F5")
    let initialElement2 = ColorElement(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1")
    let importedElement1 = ColorElement(orbHexCode: "#EDA3A8", spaceHexCode: "#F5FFF8")
    let importedElement2 = ColorElement(orbHexCode: "#A9B0B8", spaceHexCode: "#1E2633")
    
    @Test
    func canMovePaletteElement_withImportedElement_returnsTrue() {
        let availableElements = [initialElement1, initialElement2]
        
        let result = logic.canMovePaletteElement(importedElement1, availableElements: availableElements)
        
        #expect(result == true)
    }
    
    @Test
    func canMovePaletteElement_withInitialElement_returnsFalse() {
        let availableElements = [initialElement1, initialElement2]
        
        let result = logic.canMovePaletteElement(initialElement1, availableElements: availableElements)
        
        #expect(result == false)
    }
    
    @Test
    func canMovePaletteElement_withSameColorCodeAsInitial_returnsFalse() {
        let availableElements = [initialElement1, initialElement2]
        // Create a new element with same color code
        let duplicateElement = ColorElement(
            orbHexCode: initialElement1.orbHexCode,
            spaceHexCode: initialElement1.spaceHexCode
        )
        
        let result = logic.canMovePaletteElement(duplicateElement, availableElements: availableElements)
        
        #expect(result == false)
    }
    
    @Test
    func validatePaletteMovement_withValidImportedElement_returnsValid() {
        let availableElements = [initialElement1, initialElement2]
        let palette = [initialElement1, importedElement1, initialElement2]
        
        let result = logic.validatePaletteMovement(at: 1, palette: palette, availableElements: availableElements)
        
        switch result {
        case .valid(let element):
            #expect(element == importedElement1)
        case .invalid:
            Issue.record("Expected valid result but got invalid")
        }
    }
    
    @Test
    func validatePaletteMovement_withProtectedElement_returnsInvalidProtected() {
        let availableElements = [initialElement1, initialElement2]
        let palette = [initialElement1, importedElement1, initialElement2]
        
        let result = logic.validatePaletteMovement(at: 0, palette: palette, availableElements: availableElements)
        
        switch result {
        case .valid:
            Issue.record("Expected invalid result but got valid")
        case .invalid(let reason):
            #expect(reason == .protectedElement)
        }
    }
    
    @Test
    func validatePaletteMovement_withIndexOutOfBounds_returnsInvalidIndex() {
        let availableElements = [initialElement1, initialElement2]
        let palette = [initialElement1, importedElement1]
        
        let result = logic.validatePaletteMovement(at: 5, palette: palette, availableElements: availableElements)
        
        switch result {
        case .valid:
            Issue.record("Expected invalid result but got valid")
        case .invalid(let reason):
            #expect(reason == .indexOutOfBounds)
        }
    }
    
    @Test
    func validatePaletteMovement_withNegativeIndex_returnsInvalidIndex() {
        let availableElements = [initialElement1, initialElement2]
        let palette = [initialElement1, importedElement1]
        
        let result = logic.validatePaletteMovement(at: -1, palette: palette, availableElements: availableElements)
        
        switch result {
        case .valid:
            Issue.record("Expected invalid result but got valid")
        case .invalid(let reason):
            #expect(reason == .indexOutOfBounds)
        }
    }
    
    @Test
    func validatePaletteMovement_withEmptyAvailableElements_allowsAllMovements() {
        let availableElements: [ColorElement] = []
        let palette = [initialElement1, initialElement2]
        
        let result = logic.validatePaletteMovement(at: 0, palette: palette, availableElements: availableElements)
        
        switch result {
        case .valid(let element):
            #expect(element == initialElement1)
        case .invalid:
            Issue.record("Expected valid result but got invalid")
        }
    }
}