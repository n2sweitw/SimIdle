//
//  Character+Extensions.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Foundation

extension Character {
    var isHexDigit: Bool {
        return "0123456789ABCDEFabcdef".contains(self)
    }
}
