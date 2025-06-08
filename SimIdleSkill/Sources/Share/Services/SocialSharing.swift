//
//  SocialSharing.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Foundation

/// Protocol for sharing color codes to social media
protocol SocialSharing {
    @MainActor func shareColorCodes(_ elements: [ColorElement])
}

/// Protocol for copying color codes to pasteboard
protocol PasteboardCopying {
    @MainActor func copyColorCodes(_ elements: [ColorElement])
}

/// Protocol for reading color codes from pasteboard
protocol PasteboardReading {
    func readColorCodes() -> PasteboardParseResult
}

/// Result of parsing clipboard content
enum PasteboardParseResult: Equatable {
    case success([ColorElement])
    case error(String)
}
