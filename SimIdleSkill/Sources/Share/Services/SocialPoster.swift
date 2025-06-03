//
//  SocialPoster.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Foundation
import UIKit

/// Posts color codes to social media platforms
struct SocialPoster: SocialSharing {
    
    /// Posts SimIdle space codes to X (Twitter)
    /// - Parameter elements: Array of ColorElement to post
    @MainActor
    func shareColorCodes(_ elements: [ColorElement]) {
        let codes = elements.map { Self.generateColorCode(for: $0) }
        let postText = Self.generatePostText(codes: codes)
        
        guard let encodedText = postText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    /// Generates a 12-character color code by combining orb and space colors without #
    /// - Parameter element: ColorElement to generate code for
    /// - Returns: 12-character string combining orb and space colors
    static func generateColorCode(for element: ColorElement) -> String {
        let orbHex = element.orbHexCode.replacingOccurrences(of: "#", with: "")
        let spaceHex = element.spaceHexCode.replacingOccurrences(of: "#", with: "")
        return orbHex + spaceHex
    }
    
    /// Generates the post text with SimIdle space codes
    /// - Parameter codes: Array of color codes to include
    /// - Returns: Formatted post text
    private static func generatePostText(codes: [String]) -> String {
        var text = "SimIdle space codes\n"
        
        for code in codes {
            text += "\n" + code
        }
        
        text += "\n\n"
        text += "#SimIdle"
        
        return text
    }
}
