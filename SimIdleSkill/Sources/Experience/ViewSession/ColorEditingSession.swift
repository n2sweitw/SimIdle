//
//  ColorEditingSession.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

/// Represents the editing state for a single color component
struct ColorEditingState: Equatable {
    var selection: ColorCodeView.ColorComponent = .none
    var code: String
    var value: Int = 0
    private let initialCode: String
    
    var color: Color {
        Color(hexString: code)
    }
    
    var isSelected: Bool {
        selection != .none
    }
    
    init(hexString: String) {
        self.code = hexString
        self.initialCode = hexString
    }
    
    mutating func reset() {
        code = initialCode
        value = 0
        selection = .none
    }
    
    mutating func updateValue(_ newValue: Int) {
        value = newValue
    }
    
    mutating func updateCode(_ newCode: String) {
        code = newCode
    }
    
    mutating func selectComponent(_ component: ColorCodeView.ColorComponent) {
        selection = component
    }
}

/// Manages the state for color editing session
class ColorEditingSession: ObservableObject {
    @Published var orbColor: ColorEditingState
    @Published var spaceColor: ColorEditingState
    
    init(orbHexCode: String, spaceHexCode: String) {
        self.orbColor = ColorEditingState(hexString: orbHexCode)
        self.spaceColor = ColorEditingState(hexString: spaceHexCode)
    }
    
    var isOrbColorSelected: Bool {
        orbColor.isSelected
    }
    
    var isSpaceColorSelected: Bool {
        spaceColor.isSelected
    }
    
    var activeValue: Int {
        if isOrbColorSelected {
            return orbColor.value
        } else if isSpaceColorSelected {
            return spaceColor.value
        } else {
            return 0
        }
    }
    
    func updateActiveValue(_ value: Int) {
        if isOrbColorSelected {
            orbColor.updateValue(value)
        } else if isSpaceColorSelected {
            spaceColor.updateValue(value)
        }
    }
    
    func resetAll() {
        orbColor.reset()
        spaceColor.reset()
    }
    
    func hasChanges(comparedTo store: ColorStore) -> Bool {
        orbColor.code != store.orbHexCode || 
        spaceColor.code != store.spaceHexCode
    }
    
    func createElement() -> ColorElement {
        ColorElement(
            orbHexCode: orbColor.code,
            spaceHexCode: spaceColor.code
        )
    }
}
