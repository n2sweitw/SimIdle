//
//  WelcomeView.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct WelcomeView: View {
    @AppStorage("hasCompletedWelcome") private var hasCompletedWelcome: Bool = false
    private let onDismiss: () -> Void
    private let orbColor: Color
    private let spaceColor: Color
    
    private let title = "Welcome to SimIdle"
    private let welcomeText = """
SimIdle is an app where you can experience an "idle space" and reconstruct it with your own sensibility.

The interface is kept minimal. Tap or long press intuitively—many things respond to your touch.
If you find something intriguing, try tapping on it gently.

You can also tap the background with two fingers to reveal a help screen.

Give meaning to the space with your own colors.
Enjoy your journey through the idle space.
"""
    
    @State private var showMessage: Bool = false
    @State private var showOKButton: Bool = false
    
    init(onDismiss: @escaping () -> Void, orbColor: Color, spaceColor: Color) {
        self.onDismiss = onDismiss
        self.orbColor = orbColor
        self.spaceColor = spaceColor
    }
    
    var body: some View {
        ZStack {
            backgroundView
            contentLayout
        }
    }
    
    private var backgroundView: some View {
        spaceColor
            .ignoresSafeArea()
    }
    
    private var contentLayout: some View {
        VStack(spacing: 40) {
            Spacer()
            welcomeTextView
            Spacer()
            dismissButtonView
        }
    }
    
    private var welcomeTextView: some View {
        VStack(spacing: 16) {
            TypingText(
                text: title,
                textStyle: { text in
                    text
                        .foregroundColor(orbColor)
                        .font(.system(size: 16, weight: .regular))
                }
            )
            .onComplete {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showMessage = true
                }
            }
            if showMessage {
                TypingText(
                    text: welcomeText,
                    textStyle: { text in
                        text
                            .foregroundColor(orbColor)
                            .font(.system(size: 16, weight: .regular))
                    }
                )
                .onComplete {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showOKButton = true
                    }
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineSpacing(4)
            }
        }
        .padding(.horizontal, 64)
    }
    
    @ViewBuilder
    private var dismissButtonView: some View {
        if showOKButton {
            Button(action: {
                hasCompletedWelcome = true
                onDismiss()
            }) {
                Text("[ OK ]")
                    .foregroundColor(orbColor)
                    .font(.system(size: 16, weight: .regular))
                    .padding()
            }
            .transition(.opacity.combined(with: .scale))
            .padding(.bottom, 60)
        }
    }
}

#Preview {
    WelcomeView(onDismiss: {}, orbColor: .black, spaceColor: .white)
}
