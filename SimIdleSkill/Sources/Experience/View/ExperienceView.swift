//
//  ExperienceView.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI
import Combine

public struct ExperienceView: View {
    private let receivedColorElementSet: String?
    @StateObject private var colorStore: ColorStore = .init()
    @State private var currentSkill: ExperienceSkill = .idleSpace
    private var onColorUpdate: ((String) -> Void)?
    private var onBackgroundTap: (() -> Void)?

    public init(colorElementSet: String? = nil) {
        self.receivedColorElementSet = colorElementSet
    }

    public var body: some View {
        ZStack {
            background
            content
                .animation(.easeInOut(duration: 0.3), value: currentSkill)
            VStack {
                Spacer()
            }
        }
    }

    private var background: some View {
        Rectangle()
            .fill(colorStore.spaceColor)
            .ignoresSafeArea()
            .onTapGesture {
                onBackgroundTap?()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch currentSkill {
        case .idleSpace:
            IdleSpaceView(colorStore: colorStore)
                .onOrbTap {
                    withAnimation(.easeIn(duration: 0.3)) {
                        currentSkill = .colorSelection
                    }
                }
                .transition(.opacity)
        case .colorSelection:
            ColorSelectionView(currentSkill: $currentSkill, colorStore: colorStore)
                .transition(.opacity)
        }
    }
}

public extension ExperienceView {
    func onColorUpdate(_ action: @escaping (String) -> Void) -> ExperienceView {
        var view = self
        view.onColorUpdate = action
        return view
    }
    
    func onBackgroundTap(_ action: @escaping () -> Void) -> ExperienceView {
        var view = self
        view.onBackgroundTap = action
        return view
    }
}

#Preview {
    ExperienceView()
}
