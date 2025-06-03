//
//  Pasteboard.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Foundation
#if os(iOS)
import UIKit
#endif

/// Copies color codes to the system pasteboard
struct Pasteboard: PasteboardCopying {
    
    /// Copies color codes to clipboard
    /// - Parameter elements: Array of ColorElement to copy
    @MainActor
    func copyColorCodes(_ elements: [ColorElement]) {
        let colorCodes = ColorElementSet.colorCodesString(from: elements)
        
        #if os(iOS)
        UIPasteboard.general.string = colorCodes
        #endif
    }
}
