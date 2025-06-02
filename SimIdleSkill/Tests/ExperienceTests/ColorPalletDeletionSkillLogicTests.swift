//
//  ColorPalletDeletionSkillLogicTests.swift
//  SimIdleExperienceTests
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Testing
import SwiftUI
@testable import SimIdleExperience

@Suite("ColorPalletDeletion SkillLogic Tests")
struct ColorPalletDeletionSkillLogicTests {
    
    @Test("Double tap requests delete confirmation")
    func testDoubleTapRequestsDeleteConfirmation() {
        // Given
        let colorStore = ColorStore()
        colorStore.colorPallets.removeAll()
        
        // Add test colors
        let element1 = ColorElement(orbHexCode: "FF0000", spaceHexCode: "00FF00")
        let element2 = ColorElement(orbHexCode: "0000FF", spaceHexCode: "FFFF00")
        colorStore.addColorsToPallet(element: element1)
        colorStore.addColorsToPallet(element: element2)
        
        let skillLogic = ColorPalletDeletionSkillLogic(colorStore: colorStore)
        
        // When
        let action = skillLogic.determineAction(for: .longTap(index: 1))
        let result = skillLogic.executeAction(action)
        
        // Then
        #expect(action == .requestDeleteConfirmation(index: 1))
        if case .success(let resultType) = result {
            if case .deleteConfirmationRequested(let index) = resultType {
                #expect(index == 1)
            } else {
                Issue.record("Expected deleteConfirmationRequested")
            }
        } else {
            Issue.record("Expected success result")
        }
    }
    
    @Test("Confirmed delete removes color from palette")
    func testConfirmedDeleteRemovesColor() {
        // Given
        let colorStore = ColorStore()
        colorStore.colorPallets.removeAll()
        
        // Add test colors
        let element1 = ColorElement(orbHexCode: "FF0000", spaceHexCode: "00FF00")
        let element2 = ColorElement(orbHexCode: "0000FF", spaceHexCode: "FFFF00")
        let element3 = ColorElement(orbHexCode: "AAAAAA", spaceHexCode: "BBBBBB")
        colorStore.addColorsToPallet(element: element1)
        colorStore.addColorsToPallet(element: element2)
        colorStore.addColorsToPallet(element: element3)
        
        let skillLogic = ColorPalletDeletionSkillLogic(colorStore: colorStore)
        let initialCount = colorStore.colorPallets.count
        
        // When - Delete confirmation workflow
        let longTapAction = skillLogic.determineAction(for: .longTap(index: 1))
        
        let deleteAction = skillLogic.determineAction(for: .deleteConfirmed(index: 1))
        let deleteResult = skillLogic.executeAction(deleteAction)
        
        // Then
        #expect(longTapAction == .requestDeleteConfirmation(index: 1))
        #expect(deleteAction == .delete(index: 1))
        
        if case .success(let resultType) = deleteResult {
            if case .deleted(let remainingCount) = resultType {
                #expect(remainingCount == initialCount - 1)
            } else {
                Issue.record("Expected deleted result")
            }
        } else {
            Issue.record("Expected success result")
        }
        
        // Verify color was actually removed
        #expect(colorStore.colorPallets.count == initialCount - 1)
    }
    
    @Test("Invalid index returns error")
    func testInvalidIndexReturnsError() {
        // Given
        let colorStore = ColorStore()
        colorStore.colorPallets.removeAll()
        
        // Add only one color
        let element = ColorElement(orbHexCode: "FF0000", spaceHexCode: "00FF00")
        colorStore.addColorsToPallet(element: element)
        
        let skillLogic = ColorPalletDeletionSkillLogic(colorStore: colorStore)
        
        // When - Try to access invalid index
        let action = skillLogic.determineAction(for: .longTap(index: 5))
        let result = skillLogic.executeAction(action)
        
        // Then
        #expect(action == .requestDeleteConfirmation(index: 5))
        if case .failure(let error) = result {
            #expect(error == .invalidIndex)
        } else {
            Issue.record("Expected failure result")
        }
    }
    
    @Test("Delete cancel returns cancelled result")
    func testDeleteCancelReturnsCancelledResult() {
        // Given
        let colorStore = ColorStore()
        let skillLogic = ColorPalletDeletionSkillLogic(colorStore: colorStore)
        
        // When
        let action = skillLogic.determineAction(for: .deleteCancel)
        let result = skillLogic.executeAction(action)
        
        // Then
        #expect(action == .cancelDelete)
        if case .success(let resultType) = result {
            #expect(resultType == .deleteCancelled)
        } else {
            Issue.record("Expected success result")
        }
    }
}
