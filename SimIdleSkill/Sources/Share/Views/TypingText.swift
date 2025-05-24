//
//  TypingText.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI
import Combine

// MARK: - TypingTextProtocol
/// Defines the contract for text that appears with a typing animation
protocol TypingTextProtocol {
    var fullText: String { get }
    var currentText: String { get }
    var isCompleted: Bool { get }
    
    func typeNextCharacter() -> Self
    func reset() -> Self
    func complete() -> Self
}

// MARK: - TypingTextState
/// Represents the state of a typing animation
struct TypingTextState: TypingTextProtocol, Equatable {
    let fullText: String
    let currentText: String
    
    var isCompleted: Bool {
        currentText.count >= fullText.count
    }
    
    init(fullText: String) {
        self.fullText = fullText
        self.currentText = ""
    }
    
    private init(fullText: String, currentText: String) {
        self.fullText = fullText
        self.currentText = currentText
    }
    
    func typeNextCharacter() -> TypingTextState {
        guard !isCompleted else { return self }
        
        let nextIndex = currentText.count
        guard nextIndex < fullText.count else { return self }
        
        let nextCharIndex = fullText.index(fullText.startIndex, offsetBy: nextIndex)
        let nextChar = fullText[nextCharIndex]
        
        return TypingTextState(
            fullText: fullText,
            currentText: currentText + String(nextChar)
        )
    }
    
    func reset() -> TypingTextState {
        TypingTextState(fullText: fullText)
    }
    
    func complete() -> TypingTextState {
        TypingTextState(fullText: fullText, currentText: fullText)
    }
}

// MARK: - TypingTextConfiguration
/// Configuration options for typing animation
public struct TypingTextConfiguration {
    let typingInterval: TimeInterval
    let initialDelay: TimeInterval
    
    public init(
        typingInterval: TimeInterval = 0.13,
        initialDelay: TimeInterval = 0.2
    ) {
        self.typingInterval = typingInterval
        self.initialDelay = initialDelay
    }
}

// MARK: - TypingText View
/// A SwiftUI view that displays text with a typing animation effect
public struct TypingText: View {
    let text: String
    let configuration: TypingTextConfiguration
    let textStyle: (Text) -> Text
    private var completion: (() -> Void)?
    
    @State private var state: TypingTextState
    @State private var timer: AnyCancellable?
    
    public init(
        text: String,
        configuration: TypingTextConfiguration = TypingTextConfiguration(),
        textStyle: @escaping (Text) -> Text = { $0 }
    ) {
        self.text = text
        self.configuration = configuration
        self.textStyle = textStyle
        self._state = State(initialValue: TypingTextState(fullText: text))
    }
    
    public var body: some View {
        textStyle(Text(state.currentText))
            .onAppear {
                startTypingAnimation()
            }
            .onChange(of: text) { _, newText in
                state = TypingTextState(fullText: newText)
                startTypingAnimation()
            }
    }
    
    private func startTypingAnimation() {
        // Cancel any existing timer
        timer?.cancel()
        
        // Start a new timer after initial delay
        timer = Timer.publish(
            every: configuration.typingInterval,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { _ in
            guard !state.isCompleted else {
                timer?.cancel()
                completion?()
                return
            }
            
            state = state.typeNextCharacter()
        }
    }
}

public extension TypingText {
    func onComplete(_ action: @escaping () -> Void) -> Self {
        var mySelf = self
        mySelf.completion = action
        return mySelf
    }
}

#Preview {
    TypingText(text: "This is tyeping text preview\nThis label shows text like LLM chat")
}
