//
//  ColorElement.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

/// Represents a color element with orb and space colors as hex strings
struct ColorElement: Sendable, Equatable {
    let orbHexCode: String
    let spaceHexCode: String
    
    init(orbHexCode: String, spaceHexCode: String) {
        self.orbHexCode = orbHexCode
        self.spaceHexCode = spaceHexCode
    }
    
    /// Computed properties for SwiftUI display only
    var orbColor: Color {
        Color(hexString: orbHexCode)
    }
    
    var spaceColor: Color {
        Color(hexString: spaceHexCode)
    }
    
    /// Generates color code string without # prefixes
    var colorCode: String {
        let orbHex = orbHexCode.replacingOccurrences(of: "#", with: "")
        let spaceHex = spaceHexCode.replacingOccurrences(of: "#", with: "")
        return orbHex + spaceHex
    }
}
