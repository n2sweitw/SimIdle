//
//  MultiTapModifier.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct MultiTapModifier: ViewModifier {
    let onSingleTap: () -> Void
    let onTwoFingerTap: (() -> Void)?
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .overlay(
                    MultiTapGestureView(
                        onSingleTap: onSingleTap,
                        onTwoFingerTap: onTwoFingerTap,
                        size: geometry.size
                    )
                )
        }
    }
}

extension View {
    func multiTapGesture(onSingleTap: @escaping () -> Void, onTwoFingerTap: (() -> Void)? = nil) -> some View {
        modifier(MultiTapModifier(onSingleTap: onSingleTap, onTwoFingerTap: onTwoFingerTap))
    }
    
    // Convenience method for just two-finger tap (backward compatibility)
    func twoFingerTapGesture(perform action: @escaping () -> Void) -> some View {
        modifier(MultiTapModifier(onSingleTap: {}, onTwoFingerTap: action))
    }
}