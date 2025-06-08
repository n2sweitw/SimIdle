//
//  ShakableColorCircle.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct ShakableColorCircle: View {
    let element: ColorElement
    @Binding var isShaking: Bool
    @State private var shakeOffset: CGFloat = 0
    
    init(element: ColorElement, isShaking: Binding<Bool>) {
        self.element = element
        self._isShaking = isShaking
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(element.spaceColor)
                .frame(width: 24, height: 24)
            Circle()
                .fill(element.orbColor)
                .frame(width: 16, height: 16)
        }
        .frame(width: 24, height: 24)
        .offset(x: shakeOffset)
        .task(id: isShaking) {
            if isShaking {
                await performShake()
            }
        }
    }
    
    private func performShake() async {
        // Create shake animation sequence
        withAnimation(.linear(duration: 0.05)) {
            shakeOffset = -5
        }
        
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
        
        withAnimation(.linear(duration: 0.1)) {
            shakeOffset = 5
        }
        
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        withAnimation(.linear(duration: 0.1)) {
            shakeOffset = -5
        }
        
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        withAnimation(.linear(duration: 0.05)) {
            shakeOffset = 0
        }
        
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
        
        // Animation completed, reset the binding
        isShaking = false
    }
}