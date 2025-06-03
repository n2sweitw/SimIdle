//
//  ColorSharingControlsView.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct ColorSharingControlsView: View {
    @StateObject private var exportState: ColorSharingControlsState
    private let colorCandidates: [ColorElement]
    private let textColor: Color
    private let clipboardService: PasteboardCopying
    private let shareService: SocialSharing
    private var onComplete: (() -> Void)?
    
    init(
        colorCandidates: [ColorElement],
        textColor: Color,
        clipboardService: PasteboardCopying = Pasteboard(),
        shareService: SocialSharing = SocialPoster(),
        onComplete: (() -> Void)? = nil
    ) {
        self._exportState = StateObject(wrappedValue: ColorSharingControlsState())
        self.colorCandidates = colorCandidates
        self.textColor = textColor
        self.clipboardService = clipboardService
        self.shareService = shareService
        self.onComplete = onComplete
    }
    
    var body: some View {
        ZStack {
            if !exportState.isShowCopied {
                controlsView
            } else {
                completionView
            }
        }
        .frame(height: 32)
    }
    
    private var controlsView: some View {
        HStack(spacing: 16) {
            if !colorCandidates.isEmpty {
                copyButton
                postButton
                backButton
            } else {
                backButton
            }
        }
    }
    
    private var copyButton: some View {
        Text("[ Copy ]")
            .font(.system(size: 16))
            .foregroundStyle(textColor)
            .contentShape(Rectangle())
            .onTapGesture {
                handleCopyAction()
            }
    }
    
    private var postButton: some View {
        Text("[ Post ]")
            .font(.system(size: 16))
            .foregroundStyle(textColor)
            .contentShape(Rectangle())
            .onTapGesture {
                handlePostAction()
            }
    }
    
    private var backButton: some View {
        Text("[ Back ]")
            .font(.system(size: 16))
            .foregroundStyle(textColor)
            .contentShape(Rectangle())
            .onTapGesture {
                handleBackAction()
            }
    }
    
    private var completionView: some View {
        TypingText(text: "Code copied") { text in
            text
                .font(.system(size: 16))
                .foregroundColor(textColor)
        }
        .onComplete {
            hideCopiedAfterDelay()
        }
    }
    
    // MARK: - Actions
    
    private func handleCopyAction() {
        clipboardService.copyColorCodes(colorCandidates)
        withAnimation(.easeIn(duration: 0.3)) {
            exportState.showCopied()
        }
    }
    
    private func handlePostAction() {
        Task { @MainActor in
            shareService.shareColorCodes(colorCandidates)
        }
    }
    
    private func hideCopiedAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeOut(duration: 0.3)) {
                exportState.hideCopied()
            }
        }
    }
    
    private func handleBackAction() {
        onComplete?()
    }
}

extension ColorSharingControlsView {
    func onComplete(_ completion: @escaping () -> Void) -> ColorSharingControlsView {
        var copy = self
        copy.onComplete = completion
        return copy
    }
}

#Preview {
    ColorSharingControlsView(
        colorCandidates: [
            ColorElement(orbHexCode: "#4A4A4A", spaceHexCode: "#F8F8F5"),
            ColorElement(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1")
        ],
        textColor: Color(hexString: "#4A4A4A"),
        clipboardService: Pasteboard(),
        shareService: SocialPoster(),
        onComplete: {
            print("Back button tapped")
        }
    )
}
