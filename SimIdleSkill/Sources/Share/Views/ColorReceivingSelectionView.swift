//
//  ColorReceivingSelectionView.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct ColorReceivingSelectionView: View {
    let textColor: Color
    let availableElements: [ColorElement]
    @State private var selectionState: ColorReceivingSelectionState
    @State private var shakingStates: [Int: Bool] = [:]
    private var onSelectionChanged: (([ColorElement]) -> Void)?
    private let movementLogic = ColorReceivingSelectionSkillLogic()
    
    init(
        availableElements: [ColorElement],
        colorCandidates: [ColorElement] = [],
        textColor: Color
    ) {
        self.textColor = textColor
        self.availableElements = availableElements
        self._selectionState = State(initialValue: ColorReceivingSelectionState(
            availableElements: availableElements,
            colorCandidates: colorCandidates
        ))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Color candidates section
            colorCandidatesSection
                .frame(maxHeight: .infinity, alignment: .center)

            // Color palette
            colorPaletteView
        }
        .frame(height: 280)
    }
    
    private var colorCandidatesSection: some View {
        VStack(spacing: 16) {
            ForEach(Array(selectionState.colorCandidates.enumerated()), id: \.offset) { index, element in
                colorRow(element: element) {
                    moveCandidate(toPaletteAt: index)
                }
                .transition(.opacity)
            }
        }
    }
    
    private var colorPaletteView: some View {
        HStack(spacing: 24) {
            ForEach(Array(selectionState.colorPalette.enumerated()), id: \.offset) { index, element in
                ShakableColorCircle(
                    element: element,
                    isShaking: Binding(
                        get: { shakingStates[index] ?? false },
                        set: { shakingStates[index] = $0 }
                    )
                )
                .contentShape(Circle())
                .onTapGesture {
                    movePaletteColor(toCandidateAt: index)
                }
                .transition(.opacity)
            }
        }
        .frame(height: 24)
    }
    
    private func colorRow(element: ColorElement, onTap: @escaping () -> Void) -> some View {
        HStack(spacing: 16) {
            Spacer()
                .frame(width: 0)
            
            // Double circle
            ZStack {
                Circle()
                    .fill(element.spaceColor)
                    .frame(width: 24, height: 24)
                Circle()
                    .fill(element.orbColor)
                    .frame(width: 16, height: 16)
            }
            .frame(width: 24, height: 24)
            
            // Color code
            Text(element.colorCode)
                .font(.system(size: 16))
                .foregroundColor(element.orbColor)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 200)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
    
    private func moveCandidate(toPaletteAt index: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectionState = selectionState.moveCandidateToPalette(at: index)
            onSelectionChanged?(selectionState.colorPalette)
        }
    }
    
    private func movePaletteColor(toCandidateAt index: Int) {
        // Use the skill logic to validate movement
        let validationResult = movementLogic.validatePaletteMovement(
            at: index,
            palette: selectionState.colorPalette,
            availableElements: availableElements
        )
        
        switch validationResult {
        case .valid:
            withAnimation(.easeInOut(duration: 0.3)) {
                selectionState = selectionState.movePaletteToCandidate(at: index)
                onSelectionChanged?(selectionState.colorPalette)
            }
        case .invalid(let reason):
            // Movement not allowed, trigger shake animation
            if reason == .protectedElement {
                triggerShake(at: index)
            }
            return
        }
    }
    
    private func triggerShake(at index: Int) {
        // Set isShaking to true for this index
        shakingStates[index] = true
    }
    
    func update(colorCandidates elements: [ColorElement]) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectionState = selectionState.with(colorCandidates: elements)
        }
    }
    
    func clearColorCandidates() {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectionState = selectionState.clearCandidates()
        }
    }
    
    func resetColorSelection() {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectionState = selectionState.reset()
            onSelectionChanged?(selectionState.colorPalette)
        }
    }
}

extension ColorReceivingSelectionView {
    func onSelectionChange(_ action: @escaping ([ColorElement]) -> Void) -> ColorReceivingSelectionView {
        var view = self
        view.onSelectionChanged = action
        return view
    }
}

#Preview {
    ColorReceivingSelectionView(
        availableElements: [
            ColorElement(orbHexCode: "#4A4A4A", spaceHexCode: "#F8F8F5"),
            ColorElement(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1")
        ],
        colorCandidates: [
            ColorElement(orbHexCode: "#EDA3A8", spaceHexCode: "#F5FFF8"),
            ColorElement(orbHexCode: "#A9B0B8", spaceHexCode: "#1E2633")
        ],
        textColor: Color(hexString: "#4A4A4A")
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(hexString: "#F8F8F5"))
}
