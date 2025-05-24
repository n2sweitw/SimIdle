//
//  ColorElementSet
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Foundation

struct ColorElementSet: Sendable, Equatable {
    let elements: [ColorElement]
    
    init(elements: [ColorElement]) {
        self.elements = elements
    }
    
    init(from string: String) {
        self.elements = Self.parseColorElementSet(string)
    }
    
    var stringRepresentation: String {
        elements
            .map { $0.orbHexCode.replacingOccurrences(of: "#", with: "") + $0.spaceHexCode.replacingOccurrences(of: "#", with: "") }
            .joined()
    }
    
    private static func parseColorElementSet(_ colorElementSet: String) -> [ColorElement] {
        let colorCodeLength = 12 // 6 chars for orb + 6 chars for space
        var elements: [ColorElement] = []
        
        for i in stride(from: 0, to: colorElementSet.count, by: colorCodeLength) {
            let startIndex = colorElementSet.index(colorElementSet.startIndex, offsetBy: i)
            let endIndex = colorElementSet.index(startIndex, offsetBy: min(colorCodeLength, colorElementSet.count - i))
            let colorCode = String(colorElementSet[startIndex..<endIndex])
            
            if colorCode.count == colorCodeLength {
                let orbHex = "#" + String(colorCode.prefix(6))
                let spaceHex = "#" + String(colorCode.suffix(6))
                let element = ColorElement(orbHexCode: orbHex, spaceHexCode: spaceHex)
                elements.append(element)
            }
        }
        
        return elements
    }
}
