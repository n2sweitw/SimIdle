//
//  ColorImportView.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct ColorImportView: View {
    let textColor: Color
    let existingElements: [ColorElement]
    private let pasteboardReader: PasteboardReading
    private let skillLogic: ColorImportSkillLogic
    @State private var importUIState: ColorImportUIState
    private var onColorsImported: (([ColorElement]) -> Void)?
    
    init(
        textColor: Color,
        existingElements: [ColorElement] = [],
        pasteboardReader: PasteboardReading = PasteboardReader(),
        skillLogic: ColorImportSkillLogic = ColorImportSkillLogic()
    ) {
        self.textColor = textColor
        self.existingElements = existingElements
        self.pasteboardReader = pasteboardReader
        self.skillLogic = skillLogic
        self._importUIState = State(initialValue: ColorImportUIState())
    }
    
    /// Content state for display
    private var contentState: ColorImportContentState {
        if existingElements.count >= 5 {
            return .error("Palette is full")
        } else if case .error(let message) = importUIState.lastPasteResult {
            return .error(message)
        } else {
            return .empty
        }
    }
    
    var body: some View {
        centerContent
            .frame(minHeight: 100)
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
            .contentShape(Rectangle())
            .onTapGesture {
                pasteFromClipboard()
            }
    }
    
    private var centerContent: some View {
        VStack(spacing: 16) {
            switch contentState {
            case .empty:
                Text("Tap to paste color codes")
                    .font(.system(size: 16))
                    .foregroundColor(textColor)
                    .transition(.opacity)
            case .error(let message):
                Text(message)
                    .font(.system(size: 16))
                    .foregroundColor(textColor)
                    .transition(.opacity)
            case .elements:
                // This state is not used in the message-only version
                EmptyView()
            }
        }
    }
    
    private func pasteFromClipboard() {
        let result = pasteboardReader.readColorCodes()
        
        withAnimation(.easeInOut(duration: 0.3)) {
            switch result {
            case .success(let elements):
                importColors(from: elements)
            case .error:
                // Show error message
                importUIState = importUIState.withPasteResult(result)
            }
        }
    }
    
    private func importColors(from elements: [ColorElement]) {
        let event = ColorImportEvent.importRequested(
            existingElements: existingElements,
            importedElements: elements
        )
        let action = skillLogic.determineAction(for: event)
        let result = skillLogic.executeAction(action)
        
        switch result {
        case .success(let resultType):
            switch resultType {
            case .imported(let filteredElements):
                onColorsImported?(filteredElements)
                importUIState = importUIState.clearPasteResult()
            case .importRejected(let reason):
                let errorMessage = errorMessage(for: reason)
                importUIState = importUIState.withPasteResult(.error(errorMessage))
            }
        case .failure:
            importUIState = importUIState.withPasteResult(.error("Import failed"))
        }
    }
    
    private func errorMessage(for reason: ImportRejectionReason) -> String {
        switch reason {
        case .allColorsAlreadyExist:
            return "All colors already exist"
        case .tooManyColorsAfterFiltering(let maxAllowed):
            return "Too many colors (max \(maxAllowed))"
        case .paletteFull:
            return "Palette is full"
        }
    }
}

extension ColorImportView {
    func onColorsImported(_ action: @escaping ([ColorElement]) -> Void) -> ColorImportView {
        var view = self
        view.onColorsImported = action
        return view
    }
}

#Preview {
    VStack(spacing: 20) {
        ColorImportView(
            textColor: Color(hexString: "#4A4A4A"),
            existingElements: [
                ColorElement(orbHexCode: "#4A4A4A", spaceHexCode: "#F8F8F5")
            ]
        )
        .onColorsImported { colors in
            print("Imported \(colors.count) colors")
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(hexString: "#F8F8F5"))
}
