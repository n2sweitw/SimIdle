//
//  ColorPalletDeleteConfirmationView.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct ColorPalletDeleteConfirmationView: View {
    var orbColor: Color
    var onDelete: (() -> Void)?
    
    enum Step: Int, AnimationStep {
        case showText = 0
        case showButton = 1
    }
    
    @StateObject private var animationSequence = AnimationSequence(initialStep: Step.showText)
    
    var body: some View {
        HStack(spacing: 8) {
            // Step 1: Initial confirmation text
            if animationSequence.currentStep >= .showText {
                TypingText(text: "Delete this color?") {
                    $0.foregroundColor(orbColor)
                }
                .onComplete {
                    animationSequence.proceed()
                }
            }
            
            // Step 2: Show confirmation button
            if animationSequence.currentStep >= .showButton {
                Button("[ Yes ]") {
                    onDelete?()
                }
                .foregroundColor(orbColor)
                .transition(.opacity.combined(with: .move(edge: .leading)))
            }
        }
        .padding(8)
        .animation(.linear(duration: 0.25), value: animationSequence.currentStep)
        .onAppear {
            // Reset animation sequence when view appears
            animationSequence.reset(to: .showText)
        }
    }
}
