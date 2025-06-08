//
//  ColorReceivingControlsView.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct ColorReceivingControlsView: View {
    let textColor: Color
    let colorPalette: [ColorElement]
    let hasImportedColors: Bool
    private var onApply: (([ColorElement]) -> Void)?
    private var onReset: (() -> Void)?
    private var onComplete: (() -> Void)?
    
    init(
        availableElements: [ColorElement],
        colorPalette: [ColorElement],
        textColor: Color,
        hasImportedColors: Bool = false
    ) {
        self.colorPalette = colorPalette
        self.textColor = textColor
        self.hasImportedColors = hasImportedColors
    }
    
    var body: some View {
        controlButtons
    }
    
    private var controlButtons: some View {
        HStack(spacing: 8) {
            if hasImportedColors {
                Button(action: resetSelection) {
                    Text("[ Reset ]")
                        .font(.system(size: 16))
                        .foregroundColor(textColor)
                }
                
                Button(action: applyColors) {
                    Text("[ Apply ]")
                        .font(.system(size: 16))
                        .foregroundColor(textColor)
                }
            }
            
            backButton
        }
    }
    
    private var backButton: some View {
        Text("[ Back ]")
            .font(.system(size: 16))
            .foregroundColor(textColor)
            .contentShape(Rectangle())
            .onTapGesture {
                onComplete?()
            }
    }
    
    private func applyColors() {
        onApply?(colorPalette)
    }
    
    private func resetSelection() {
        onReset?()
    }
}

extension ColorReceivingControlsView {
    func onApply(_ action: @escaping ([ColorElement]) -> Void) -> ColorReceivingControlsView {
        var view = self
        view.onApply = action
        return view
    }
    
    func onReset(_ action: @escaping () -> Void) -> ColorReceivingControlsView {
        var view = self
        view.onReset = action
        return view
    }
    
    func onCompletion(_ action: @escaping () -> Void) -> ColorReceivingControlsView {
        var view = self
        view.onComplete = action
        return view
    }
}

#Preview {
    ColorReceivingControlsView(
        availableElements: [
            ColorElement(orbHexCode: "#4A4A4A", spaceHexCode: "#F8F8F5"),
            ColorElement(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1")
        ],
        colorPalette: [
            ColorElement(orbHexCode: "#4A4A4A", spaceHexCode: "#F8F8F5")
        ],
        textColor: Color(hexString: "#4A4A4A"),
        hasImportedColors: true
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(hexString: "#F8F8F5"))
}