//
//  ColorSharingControlsState.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

class ColorSharingControlsState: ObservableObject {
    @Published var isShowCopied: Bool = false
    
    func showCopied() {
        isShowCopied = true
    }
    
    func hideCopied() {
        isShowCopied = false
    }
}