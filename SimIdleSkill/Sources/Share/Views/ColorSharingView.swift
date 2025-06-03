//
//  ColorSharingView.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct ColorSharingView: View {
    private let textColor: Color
    private let backgroundColor: Color
    private let clipboardService: PasteboardCopying
    private let shareService: SocialSharing
    private var onComplete: (() -> Void)?
    private let initialElements: [ColorElement]
    
    @State private var colorCandidates: [ColorElement] = []
    
    init(
        elements: [ColorElement],
        textColor: Color,
        backgroundColor: Color,
        clipboardService: PasteboardCopying = Pasteboard(),
        shareService: SocialSharing = SocialPoster(),
        onComplete: (() -> Void)? = nil
    ) {
        self.initialElements = elements
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.clipboardService = clipboardService
        self.shareService = shareService
        self.onComplete = onComplete
    }
    
    var body: some View {
        ZStack {
            backgroundView
            contentView
        }
    }
    
    private var backgroundView: some View {
        Rectangle()
            .fill(backgroundColor)
            .ignoresSafeArea()
    }
    
    private var contentView: some View {
        VStack {
            Spacer()
            
            ColorSharingSelectionView(
                elements: initialElements,
                textColor: textColor
            ) { candidates in
                withAnimation(.easeIn(duration: 0.45)) {
                    colorCandidates = candidates
                }
            }

            Spacer()

            ColorSharingControlsView(
                colorCandidates: colorCandidates,
                textColor: textColor,
                clipboardService: clipboardService,
                shareService: shareService
            ) {
                handleBackAction()
            }
            .transition(.opacity)
            .frame(height: 32)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    // MARK: - Actions
    
    private func handleBackAction() {
        onComplete?()
    }
}

extension ColorSharingView {
    func onComplete(_ completion: @escaping () -> Void) -> ColorSharingView {
        var copy = self
        copy.onComplete = completion
        return copy
    }
}

#Preview {
    ColorSharingView(
        elements: [
            ColorElement(orbHexCode: "#4A4A4A", spaceHexCode: "#F8F8F5"),
            ColorElement(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1"),
            ColorElement(orbHexCode: "#EDA3A8", spaceHexCode: "#F5FFF8"),
            ColorElement(orbHexCode: "#A9B0B8", spaceHexCode: "#1E2633"),
            ColorElement(orbHexCode: "#A9B0B8", spaceHexCode: "#1E2633")
        ],
        textColor: Color(hexString: "#4A4A4A"),
        backgroundColor: Color(hexString: "#F8F8F5"),
        clipboardService: Pasteboard(),
        shareService: SocialPoster(),
        onComplete: {
            print("Color sharing completed")
        }
    )
}
