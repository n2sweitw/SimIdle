//
//  ColorImportState.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Foundation

/// Content display state for color importing
enum ColorImportContentState: Equatable {
    case empty
    case error(String)
    case elements([ColorElement])
}

/// UI state for color import interface
struct ColorImportUIState: Equatable {
    let lastPasteResult: PasteboardParseResult?
    
    init() {
        self.lastPasteResult = nil
    }
    
    private init(lastPasteResult: PasteboardParseResult?) {
        self.lastPasteResult = lastPasteResult
    }
    
    /// Updates with paste result
    func withPasteResult(_ result: PasteboardParseResult) -> ColorImportUIState {
        ColorImportUIState(lastPasteResult: result)
    }
    
    /// Clears paste result
    func clearPasteResult() -> ColorImportUIState {
        ColorImportUIState(lastPasteResult: nil)
    }
}
