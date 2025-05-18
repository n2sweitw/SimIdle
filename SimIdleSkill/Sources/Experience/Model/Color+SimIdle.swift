//
//  Color+SimIdle.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

extension Color {
    struct PresetColor: Sendable {
        let defaultColor = ColorElement(orbHexCode: "#4A4A4A", spaceHexCode: "#F8F8F5")
        
        var defaultOrbHex: String {
            defaultColor.orbHexCode
        }
        
        var defaultSpacedHex: String {
            defaultColor.spaceHexCode
        }

        var defaultOrb: Color {
            defaultColor.orbColor
        }

        var defaultSpace: Color {
            defaultColor.spaceColor
        }

        let palette: [ColorElement] = [
            // Uturo
            ColorElement(orbHexCode: "#4A4A4A", spaceHexCode: "#F8F8F5"),
            // Madoromi
            ColorElement(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1"),
            // Yawaragi
            ColorElement(orbHexCode: "#E28FA6", spaceHexCode: "#FFF7F9"),
            // Shijima
            ColorElement(orbHexCode: "#A9B0B8", spaceHexCode: "#1E2633")
        ]
    }

    static let preset = PresetColor()
}
