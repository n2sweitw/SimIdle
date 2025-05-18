//
//  ColorSelectionSkillLogicTests.swift
//  SimIdleExperienceTests
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Testing
import SwiftUI
@testable import SimIdleExperience

@Suite("ColorSelection SkillLogic Tests")
struct ColorSelectionSkillLogicTests {
    
    @Test("Add color when palette has space")
    func testAddColorWhenPaletteHasSpace() {
        // Given
        let colorStore = ColorStore()
        // Clear default palettes to start with empty state
        colorStore.colorPallets.removeAll()
        
        let skillLogic = ColorSelectionSkillLogic(colorStore: colorStore)
        let session = ColorEditingSession(orbHexCode: "FF0000", spaceHexCode: "00FF00")
        
        // Verify palette has space
        #expect(colorStore.colorPallets.count < colorStore.maxPallets)
        
        // When
        let action = skillLogic.determineAction(for: session)
        let result = skillLogic.executeAction(action, with: session)
        
        // Then
        #expect(action == .add)
        if case .success(let actionType) = result {
            #expect(actionType == .added)
        } else {
            Issue.record("Expected success result")
        }
        
        // Verify color was added to palette
        #expect(colorStore.colorPallets.count == 1)
        #expect(colorStore.colorPallets.first?.orbHexCode == "FF0000")
        #expect(colorStore.colorPallets.first?.spaceHexCode == "00FF00")
    }
    
    @Test("Replace current color when palette is full")
    func testReplaceColorWhenPaletteIsFull() {
        // Given
        let colorStore = ColorStore()
        // Clear default palettes and manually fill to capacity
        colorStore.colorPallets.removeAll()
        
        // Fill palette to maximum capacity
        for i in 0..<colorStore.maxPallets {
            let element = ColorElement(
                orbHexCode: String(format: "%06X", i * 0x111111),
                spaceHexCode: String(format: "%06X", (i + 1) * 0x111111)
            )
            colorStore.addColorsToPallet(element: element)
        }
        
        let skillLogic = ColorSelectionSkillLogic(colorStore: colorStore)
        let initialCount = colorStore.colorPallets.count
        
        // Verify palette is full
        #expect(colorStore.colorPallets.count == colorStore.maxPallets)
        
        let session = ColorEditingSession(orbHexCode: "FF0000", spaceHexCode: "00FF00")
        
        // When
        let action = skillLogic.determineAction(for: session)
        let result = skillLogic.executeAction(action, with: session)
        
        // Then
        #expect(action == .apply)
        if case .success(let actionType) = result {
            #expect(actionType == .applied)
        } else {
            Issue.record("Expected success result")
        }
        
        // Verify palette size unchanged and current colors updated
        #expect(colorStore.colorPallets.count == initialCount)
        #expect(colorStore.orbHexCode == "FF0000")
        #expect(colorStore.spaceHexCode == "00FF00")
    }
}
