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

/// Reads and parses color codes from the system pasteboard
struct PasteboardReader: PasteboardReading {
    
    /// Maximum number of color elements allowed
    private let maxElements = 5
    
    /// Reads and parses color codes from clipboard
    /// - Returns: ParseResult with elements or error message
    func readColorCodes() -> PasteboardParseResult {
        #if os(iOS)
        guard let clipboardText = UIPasteboard.general.string else {
            return .error("Clipboard is empty")
        }
        #else
        let clipboardText = ""
        #endif
        
        return parseColorCodes(from: clipboardText)
    }
    
    /// Parses color codes from text
    /// - Parameter text: Text containing color codes
    /// - Returns: ParseResult with elements or error message
    private func parseColorCodes(from text: String) -> PasteboardParseResult {
        let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if text length is divisible by 12
        guard cleanedText.count % 12 == 0 else {
            return .error("Invalid format")
        }
        
        let elementCount = cleanedText.count / 12
        
        // Check maximum elements
        guard elementCount <= maxElements else {
            return .error("Too many colors (max \(maxElements))")
        }
        
        guard elementCount > 0 else {
            return .error("No color codes found")
        }
        
        var elements: [ColorElement] = []
        
        for i in 0..<elementCount {
            let startIndex = cleanedText.index(cleanedText.startIndex, offsetBy: i * 12)
            let endIndex = cleanedText.index(startIndex, offsetBy: 12)
            let colorCode = String(cleanedText[startIndex..<endIndex])
            
            // Validate hex characters
            guard colorCode.allSatisfy({ $0.isHexDigit }) else {
                return .error("Invalid hex color code")
            }
            
            let orbHex = "#" + String(colorCode.prefix(6))
            let spaceHex = "#" + String(colorCode.suffix(6))
            
            elements.append(ColorElement(orbHexCode: orbHex, spaceHexCode: spaceHex))
        }
        
        return .success(elements)
    }
}
