//
//  HelpView.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct HelpView: View {
    let onDismiss: () -> Void
    let orbColor: Color
    let spaceColor: Color
    @State private var showContent = false
    @State private var titleAnimationComplete = false
    
    var body: some View {
        VStack(spacing: 30) {
            TypingText(
                text: "How to Move in This Space"
            )
            .onComplete {
                titleAnimationComplete = true
                withAnimation(.easeIn(duration: 0.5)) {
                    showContent = true
                }
            }
            .foregroundColor(orbColor)
            .font(.system(size: 20))
            .fontWeight(.semibold)
            .padding(.top, 50)
            
            if showContent {
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        helpSection(
                            title: "Choosing Colors",
                            content: [
                                "Tap R, G, or B in the center color code to select it.",
                                "Swipe the background to adjust the selected color value.",
                                "The color changes will affect the orb and the space.",
                            ]
                        )
                        
                        helpSection(
                            title: "Saving and Switching Colors",
                            content: [
                                "The double circles at the bottom are saved color slots.",
                                "Tap a circle to apply its color.",
                                "Long-press a circle to delete it.",
                            ]
                        )

                        helpSection(
                            title: "How to See This Help Again",
                            content: [
                                "Tap the space with two fingers to bring up this help again.",
                            ]
                        )
                    }
                    .padding(.horizontal, 30)
                }
                .opacity(showContent ? 1 : 0)
            }
            
            Spacer()
            
            if showContent {
                Button(action: onDismiss) {
                    Text("[ OK ]")
                        .foregroundColor(orbColor)
                        .padding()
                }
                .opacity(showContent ? 1 : 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(spaceColor)
    }
    
    private func helpSection(title: String, content: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(orbColor)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(content, id: \.self) { text in
                    Text("• \(text)")
                        .foregroundColor(orbColor.opacity(0.7))
                }
            }
        }
    }
}

#Preview {
    HelpView(onDismiss: {}, orbColor: .black, spaceColor: .white)
}
