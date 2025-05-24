//
//  MenuView.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct MenuView: View {
    @Binding private var currentSkill: ShareSkill
    private let orbColor: Color
    private let backgroundColor: Color
    private let onComplete: (() -> Void)?
    
    init(currentView: Binding<ShareSkill>, orbColor: Color, backgroundColor: Color, onComplete: (() -> Void)? = nil) {
        self._currentSkill = currentView
        self.orbColor = orbColor
        self.backgroundColor = backgroundColor
        self.onComplete = onComplete
    }
    
    public var body: some View {
        ZStack {
            background
            buttons
                .frame(width: 230)
        }
    }
    
    private var buttons: some View {
        VStack(spacing: 16) {
            shareColor
            receiveColor
        }
    }

    private var shareColor: some View {
        MenuItemView(text: "Share Your Space", orbColor: orbColor) {
            currentSkill = .colorSharing
        }
    }
    
    private var receiveColor: some View {
        MenuItemView(text: "Receive Space", orbColor: orbColor) {
            currentSkill = .colorReceiving
        }
    }

    var background: some View {
        backgroundColor
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture {
                onComplete?()
            }
    }
}

private extension MenuView {
    struct MenuItemView: View {
        let text: String
        var orbColor: Color
        var onTap: (() -> Void)?
        @State private var isShowButton = false
        var body: some View {
            HStack(spacing: 8) {
                TypingText(text: text) {
                    $0.foregroundColor(orbColor)
                }
                .onComplete {
                    withAnimation(.linear(duration: 0.25)) {
                        isShowButton = true
                    }
                }
                Spacer()
                if isShowButton {
                    Button("[ Yes ]") {
                        onTap?()
                    }
                    .foregroundColor(orbColor)
                }
            }
            .padding(8)
        }
    }
}

#Preview {
    MenuView(
        currentView: .constant(.menu),
        orbColor: Color(hexString: "#3BB6A2"),
        backgroundColor: Color(hexString: "#FFF8E1")
    )
}
