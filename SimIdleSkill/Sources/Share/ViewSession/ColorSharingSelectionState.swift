//
//  ColorSharingSelectionState.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

class ColorSharingSelectionState: ObservableObject {
    @Published var availableElements: [ColorElement]
    @Published var colorCandidates: [ColorElement] = []
    
    init(elements: [ColorElement]) {
        self.availableElements = elements
    }
    
    func selectElement(_ element: ColorElement) {
        colorCandidates.append(element)
        availableElements.removeAll { $0.colorCode == element.colorCode }
    }
    
    func removeElement(_ element: ColorElement) {
        colorCandidates.removeAll { $0.colorCode == element.colorCode }
        availableElements.append(element)
    }
    
    var hasAvailableElements: Bool {
        !availableElements.isEmpty
    }
}
