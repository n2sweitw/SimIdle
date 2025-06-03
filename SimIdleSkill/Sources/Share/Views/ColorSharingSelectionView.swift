//
//  ColorSharingSelectionView.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct ColorSharingSelectionView: View {
    @StateObject private var selectionState: ColorSharingSelectionState
    private let textColor: Color
    private let onSelectionChanged: ([ColorElement]) -> Void
    
    init(
        elements: [ColorElement],
        textColor: Color,
        onSelectionChanged: @escaping ([ColorElement]) -> Void
    ) {
        self._selectionState = StateObject(wrappedValue: ColorSharingSelectionState(elements: elements))
        self.textColor = textColor
        self.onSelectionChanged = onSelectionChanged
    }
    
    var body: some View {
        VStack(spacing: 24) {
            centerContent
                .frame(maxHeight: .infinity, alignment: .center)
                .transition(.opacity)
            
            availableElementsView
        }
        .frame(height: 250)
        .onChange(of: selectionState.colorCandidates) { _, newValue in
            onSelectionChanged(newValue)
        }
    }
    
    @ViewBuilder
    private var centerContent: some View {
        if selectionState.colorCandidates.isEmpty {
            explanationView
        } else {
            colorCandidatesView
        }
    }
    
    private var explanationView: some View {
        Text("Select a color from the palette")
            .foregroundColor(textColor)
    }
    
    private var colorCandidatesView: some View {
        VStack {
            ForEach(Array(selectionState.colorCandidates.enumerated()), id: \.offset) { _, element in
                colorCandidateRow(for: element)
                    .transition(.opacity)
            }
        }
    }
    
    private func colorCandidateRow(for element: ColorElement) -> some View {
        HStack(spacing: 16) {
            Spacer()
                .frame(width: 0)
            
            elementCircleView(for: element)
            
            Text(element.colorCode)
                .foregroundColor(element.orbColor)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 200)
        .contentShape(Rectangle())
        .onTapGesture {
            removeElement(element)
        }
    }
    
    private var availableElementsView: some View {
        Group {
            if selectionState.hasAvailableElements {
                colorPalette
                    .frame(height: 32)
            } else {
                Color.clear
                    .frame(height: 32)
            }
        }
    }
    
    private var colorPalette: some View {
        HStack(spacing: 24) {
            ForEach(Array(selectionState.availableElements.enumerated()), id: \.offset) { _, element in
                availableElementCircle(for: element)
                    .transition(.opacity)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // Prevent background tap gesture propagation
        }
    }
    
    private func availableElementCircle(for element: ColorElement) -> some View {
        elementCircleView(for: element)
            .contentShape(Circle())
            .onTapGesture {
                selectElement(element)
            }
    }
    
    private func elementCircleView(for element: ColorElement) -> some View {
        ZStack {
            Circle()
                .fill(element.spaceColor)
                .frame(width: 24, height: 24)
            Circle()
                .fill(element.orbColor)
                .frame(width: 16, height: 16)
        }
        .frame(width: 24, height: 24)
    }
    
    // MARK: - Actions
    
    private func selectElement(_ element: ColorElement) {
        withAnimation(.easeOut(duration: 0.3)) {
            selectionState.selectElement(element)
        }
    }
    
    private func removeElement(_ element: ColorElement) {
        withAnimation(.easeOut(duration: 0.3)) {
            selectionState.removeElement(element)
        }
    }
}

#Preview {
    ColorSharingSelectionView(
        elements: [
            ColorElement(orbHexCode: "#4A4A4A", spaceHexCode: "#F8F8F5"),
            ColorElement(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1"),
            ColorElement(orbHexCode: "#EDA3A8", spaceHexCode: "#F5FFF8")
        ],
        textColor: Color(hexString: "#4A4A4A")
    ) { colorCandidates in
        print("Selected elements: \(colorCandidates.count)")
    }
}
