//
//  SimIdleView.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct IdleSpaceView: View {
    private var onOrbTap: (() -> Void)?

    init() {}

    var body: some View {
        ZStack {
            background
            OrbView(orbColor: Color("circleColor"), onTap: onOrbTap)
        }
        .ignoresSafeArea()
    }

    var background: some View {
        Color("backgroundColor")
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}

extension IdleSpaceView {
    func onOrbTap(_ action: @escaping () -> Void) -> IdleSpaceView {
        var view = self
        view.onOrbTap = action
        return view
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    IdleSpaceView()
}
