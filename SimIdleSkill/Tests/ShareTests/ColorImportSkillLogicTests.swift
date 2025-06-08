//
//  ColorImportSkillLogicTests.swift
//  SimIdleShareTests
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Testing
@testable import SimIdleShare

@Suite("ColorImportSkillLogic Tests")
struct ColorImportSkillLogicTests {
    let skillLogic = ColorImportSkillLogic()
    
    // MARK: - determineAction Tests
    
    @Test("determineAction for importRequested with unique colors")
    func determineActionImportRequestedUniqueColors() {
        // Given - all imported colors are unique
        let existingElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000")
        ]
        let importedElements = [
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111"),
            ColorElement(orbHexCode: "#0000FF", spaceHexCode: "#222222")
        ]
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: importedElements
        )
        
        // When
        let action = skillLogic.determineAction(for: event)
        
        // Then
        #expect(action == .importColors(filteredElements: importedElements))
    }
    
    @Test("determineAction for importRequested with duplicate colors")
    func determineActionImportRequestedDuplicateColors() {
        // Given - some imported colors already exist
        let existingElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000"),
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111")
        ]
        let importedElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000"), // Duplicate
            ColorElement(orbHexCode: "#0000FF", spaceHexCode: "#222222")  // Unique
        ]
        let expectedFiltered = [
            ColorElement(orbHexCode: "#0000FF", spaceHexCode: "#222222")
        ]
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: importedElements
        )
        
        // When
        let action = skillLogic.determineAction(for: event)
        
        // Then
        #expect(action == .importColors(filteredElements: expectedFiltered))
    }
    
    @Test("determineAction for importRequested with all duplicate colors")
    func determineActionImportRequestedAllDuplicateColors() {
        // Given - all imported colors already exist
        let existingElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000"),
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111")
        ]
        let importedElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000"),
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111")
        ]
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: importedElements
        )
        
        // When
        let action = skillLogic.determineAction(for: event)
        
        // Then
        #expect(action == .rejectImport(reason: .allColorsAlreadyExist))
    }
    
    @Test("determineAction for importRequested exceeding max colors")
    func determineActionImportRequestedExceedingMaxColors() {
        // Given - import would exceed max limit per import operation (5)
        let existingElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000")
        ]
        let importedElements = [
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111"),
            ColorElement(orbHexCode: "#0000FF", spaceHexCode: "#222222"),
            ColorElement(orbHexCode: "#FFFF00", spaceHexCode: "#333333"),
            ColorElement(orbHexCode: "#FF00FF", spaceHexCode: "#444444"),
            ColorElement(orbHexCode: "#00FFFF", spaceHexCode: "#555555"),
            ColorElement(orbHexCode: "#808080", spaceHexCode: "#666666")
        ]
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: importedElements
        )
        
        // When
        let action = skillLogic.determineAction(for: event)
        
        // Then
        #expect(action == .rejectImport(reason: .tooManyColorsAfterFiltering(maxAllowed: 5)))
    }
    
    @Test("determineAction for importRequested at exact max limit")
    func determineActionImportRequestedAtExactMaxLimit() {
        // Given - import reaches exactly max limit per import operation (5)
        let existingElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000")
        ]
        let importedElements = [
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111"),
            ColorElement(orbHexCode: "#0000FF", spaceHexCode: "#222222"),
            ColorElement(orbHexCode: "#FFFF00", spaceHexCode: "#333333"),
            ColorElement(orbHexCode: "#FF00FF", spaceHexCode: "#444444"),
            ColorElement(orbHexCode: "#00FFFF", spaceHexCode: "#555555")
        ]
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: importedElements
        )
        
        // When
        let action = skillLogic.determineAction(for: event)
        
        // Then
        #expect(action == .importColors(filteredElements: importedElements))
    }
    
    @Test("determineAction for importRequested with custom max limit")
    func determineActionImportRequestedCustomMaxLimit() {
        // Given - custom max limit of 3
        let customSkillLogic = ColorImportSkillLogic(maxElements: 3)
        let existingElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000")
        ]
        let importedElements = [
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111"),
            ColorElement(orbHexCode: "#0000FF", spaceHexCode: "#222222"),
            ColorElement(orbHexCode: "#FFFF00", spaceHexCode: "#333333"),
            ColorElement(orbHexCode: "#FF00FF", spaceHexCode: "#444444")
        ]
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: importedElements
        )
        
        // When
        let action = customSkillLogic.determineAction(for: event)
        
        // Then
        #expect(action == .rejectImport(reason: .tooManyColorsAfterFiltering(maxAllowed: 3)))
    }
    
    @Test("determineAction for importRequested with empty existing elements")
    func determineActionImportRequestedEmptyExisting() {
        // Given - no existing colors
        let existingElements: [ColorElement] = []
        let importedElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000"),
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111")
        ]
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: importedElements
        )
        
        // When
        let action = skillLogic.determineAction(for: event)
        
        // Then
        #expect(action == .importColors(filteredElements: importedElements))
    }
    
    @Test("determineAction for importRequested with empty imported elements")
    func determineActionImportRequestedEmptyImported() {
        // Given - no imported colors
        let existingElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000")
        ]
        let importedElements: [ColorElement] = []
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: importedElements
        )
        
        // When
        let action = skillLogic.determineAction(for: event)
        
        // Then
        #expect(action == .rejectImport(reason: .allColorsAlreadyExist))
    }
    
    // MARK: - executeAction Tests
    
    @Test("executeAction for import")
    func executeActionImport() {
        // Given
        let filteredElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000")
        ]
        let action = ColorImportAction.importColors(filteredElements: filteredElements)
        
        // When
        let result = skillLogic.executeAction(action)
        
        // Then
        #expect(result == .success(.imported(filteredElements: filteredElements)))
    }
    
    @Test("executeAction for rejectImport with allColorsAlreadyExist")
    func executeActionRejectImportAllColorsExist() {
        // Given
        let action = ColorImportAction.rejectImport(reason: .allColorsAlreadyExist)
        
        // When
        let result = skillLogic.executeAction(action)
        
        // Then
        #expect(result == .success(.importRejected(reason: .allColorsAlreadyExist)))
    }
    
    @Test("executeAction for rejectImport with tooManyColors")
    func executeActionRejectImportTooManyColors() {
        // Given
        let action = ColorImportAction.rejectImport(reason: .tooManyColorsAfterFiltering(maxAllowed: 5))
        
        // When
        let result = skillLogic.executeAction(action)
        
        // Then
        #expect(result == .success(.importRejected(reason: .tooManyColorsAfterFiltering(maxAllowed: 5))))
    }
    
    // MARK: - Integration Tests
    
    @Test("Full import workflow with successful filtering")
    func fullImportWorkflowSuccessfulFiltering() {
        // Given - mixed duplicate and unique colors
        let existingElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000")
        ]
        let importedElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000"), // Duplicate
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111")  // Unique
        ]
        let expectedFiltered = [
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111")
        ]
        
        // When
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: importedElements
        )
        let action = skillLogic.determineAction(for: event)
        let result = skillLogic.executeAction(action)
        
        // Then
        #expect(result == .success(.imported(filteredElements: expectedFiltered)))
    }
    
    @Test("Full import workflow with all duplicates rejection")
    func fullImportWorkflowAllDuplicatesRejection() {
        // Given - all colors are duplicates
        let existingElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000"),
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111")
        ]
        let importedElements = existingElements
        
        // When
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: importedElements
        )
        let action = skillLogic.determineAction(for: event)
        let result = skillLogic.executeAction(action)
        
        // Then
        #expect(result == .success(.importRejected(reason: .allColorsAlreadyExist)))
    }
    
    @Test("Full import workflow with max limit rejection")
    func fullImportWorkflowMaxLimitRejection() {
        // Given - import would exceed max limit per import operation
        let existingElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000")
        ]
        let importedElements = [
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111"),
            ColorElement(orbHexCode: "#0000FF", spaceHexCode: "#222222"),
            ColorElement(orbHexCode: "#FFFF00", spaceHexCode: "#333333"),
            ColorElement(orbHexCode: "#FF00FF", spaceHexCode: "#444444"),
            ColorElement(orbHexCode: "#00FFFF", spaceHexCode: "#555555"),
            ColorElement(orbHexCode: "#808080", spaceHexCode: "#666666")
        ]
        
        // When
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: importedElements
        )
        let action = skillLogic.determineAction(for: event)
        let result = skillLogic.executeAction(action)
        
        // Then
        #expect(result == .success(.importRejected(reason: .tooManyColorsAfterFiltering(maxAllowed: 5))))
    }
    
    @Test("Full import workflow with partial filtering within max limit")
    func fullImportWorkflowPartialFilteringWithinMaxLimit() {
        // Given - some duplicates, but remaining is within limit
        let existingElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000"),
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111")
        ]
        let importedElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000"), // Duplicate - will be filtered
            ColorElement(orbHexCode: "#FFFF00", spaceHexCode: "#333333"), // Unique
            ColorElement(orbHexCode: "#FF00FF", spaceHexCode: "#444444"), // Unique
            ColorElement(orbHexCode: "#00FFFF", spaceHexCode: "#555555")  // Unique
        ]
        let expectedFiltered = [
            ColorElement(orbHexCode: "#FFFF00", spaceHexCode: "#333333"),
            ColorElement(orbHexCode: "#FF00FF", spaceHexCode: "#444444"),
            ColorElement(orbHexCode: "#00FFFF", spaceHexCode: "#555555")
        ]
        
        // When
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: importedElements
        )
        let action = skillLogic.determineAction(for: event)
        let result = skillLogic.executeAction(action)
        
        // Then - should succeed because only 3 unique colors to import
        #expect(result == .success(.imported(filteredElements: expectedFiltered)))
    }
    
    @Test("determineAction for importRequested when palette is full")
    func determineActionImportRequestedPaletteFull() {
        // Given - palette already has 5 colors (full)
        let existingElements = [
            ColorElement(orbHexCode: "#FF0000", spaceHexCode: "#000000"),
            ColorElement(orbHexCode: "#00FF00", spaceHexCode: "#111111"),
            ColorElement(orbHexCode: "#0000FF", spaceHexCode: "#222222"),
            ColorElement(orbHexCode: "#FFFF00", spaceHexCode: "#333333"),
            ColorElement(orbHexCode: "#FF00FF", spaceHexCode: "#444444")
        ]
        let importedElements = [
            ColorElement(orbHexCode: "#00FFFF", spaceHexCode: "#555555")
        ]
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: importedElements
        )
        
        // When
        let action = skillLogic.determineAction(for: event)
        
        // Then
        #expect(action == .rejectImport(reason: .paletteFull))
    }
    
    @Test("executeAction for rejectImport with paletteFull")
    func executeActionRejectImportPaletteFull() {
        // Given
        let action = ColorImportAction.rejectImport(reason: .paletteFull)
        
        // When
        let result = skillLogic.executeAction(action)
        
        // Then
        #expect(result == .success(.importRejected(reason: .paletteFull)))
    }
}
