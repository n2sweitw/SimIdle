//
//  ColorReceivingView.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct ColorReceivingView: View {
    let textColor: Color
    let backgroundColor: Color
    private let initialElements: [ColorElement]
    private let pasteboardReader: PasteboardReading
    private var onColorsImported: ((String) -> Void)?
    private var onComplete: (() -> Void)?
    
    @State private var colorPalette: [ColorElement]
    @State private var colorCandidates: [ColorElement] = []
    @State private var hasImportedColors: Bool = false
    
    init(
        textColor: Color,
        backgroundColor: Color,
        allElements: [ColorElement] = [],
        colorCandidates: [ColorElement] = [],
        pasteboardReader: PasteboardReading = PasteboardReader()
    ) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.initialElements = allElements
        self.pasteboardReader = pasteboardReader
        self._colorPalette = State(initialValue: allElements)
        self._colorCandidates = State(initialValue: colorCandidates)
        self._hasImportedColors = State(initialValue: !colorCandidates.isEmpty)
    }
    
    var body: some View {
        contentView
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundView)
            .animation(.easeInOut(duration: 0.3), value: hasImportedColors)
    }
    
    @ViewBuilder
    private var contentView: some View {
        VStack(spacing: 0) {
            Spacer()

            if hasImportedColors {
                colorSelectionView
                    .transition(.opacity)
            } else {
                colorImportView
            }
            
            Spacer()
            
            colorControlsView
                .padding(.bottom, 60)
        }
    }
    
    private var colorSelectionView: some View {
        ColorReceivingSelectionView(
            availableElements: initialElements,
            colorCandidates: colorCandidates,
            textColor: textColor
        )
        .onSelectionChange { elements in
            colorPalette = elements
        }
    }
    
    private var colorControlsView: some View {
        ColorReceivingControlsView(
            availableElements: initialElements,
            colorPalette: colorPalette,
            textColor: textColor,
            hasImportedColors: hasImportedColors
        )
        .onApply { elements in
            apply(selectedColors: elements)
        }
        .onReset {
            resetColorSelection()
        }
        .onCompletion {
            onComplete?()
        }
        .frame(height: 32)
    }
    
    private var colorImportView: some View {
        ColorImportView(
            textColor: textColor,
            existingElements: initialElements,
            pasteboardReader: pasteboardReader
        )
        .onColorsImported { elements in
            updateWith(importedColors: elements)
        }
    }
    
    private var backgroundView: some View {
        backgroundColor
            .ignoresSafeArea()
    }
    
    private func updateWith(importedColors elements: [ColorElement]) {
        withAnimation(.easeInOut(duration: 0.3)) {
            colorCandidates = elements
            hasImportedColors = true
        }
    }
    
    private func resetColorSelection() {
        withAnimation(.easeInOut(duration: 0.3)) {
            colorCandidates = []
            colorPalette = initialElements
            hasImportedColors = false
        }
    }
    
    private func apply(selectedColors elements: [ColorElement]) {
        let colorElementSet = ColorElementSet.colorCodesString(from: elements)
        onColorsImported?(colorElementSet)
        onComplete?()
    }
}

extension ColorReceivingView {
    func onImport(_ action: @escaping (String) -> Void) -> ColorReceivingView {
        var view = self
        view.onColorsImported = action
        return view
    }
    
    func onCompletion(_ action: @escaping () -> Void) -> ColorReceivingView {
        var view = self
        view.onComplete = action
        return view
    }
}

#Preview {
    // Preview with Uturo and Madoromi as color candidates
    return ColorReceivingView(
        textColor: Color(hexString: "#4A4A4A"),
        backgroundColor: Color(hexString: "#F8F8F5"),
        allElements: []
    )
}

#Preview("imported") {
    // Preview with Uturo and Madoromi as color candidates
    return ColorReceivingView(
        textColor: Color(hexString: "#4A4A4A"),
        backgroundColor: Color(hexString: "#F8F8F5"),
        allElements: [],
        colorCandidates: [
            ColorElement(orbHexCode: "#4A4A4A", spaceHexCode: "#F8F8F5"), // Uturo
            ColorElement(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1")  // Madoromi
        ]
    )
}
