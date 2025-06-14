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
    private var onColorUpdate: ((String) -> Void)?
    private var onBackgroundTap: (() -> Void)?

    public init(colorElementSet: String? = nil) {
        self.receivedColorElementSet = colorElementSet
    }

    public var body: some View {
        ZStack {
            background
            content
            VStack {
                Spacer()
            }
        }
    }

    private var background: some View {
        Rectangle()
            .fill(Color("backgroundColor"))
            .ignoresSafeArea()
            .onTapGesture {
                onBackgroundTap?()
            }
    }

    @ViewBuilder
    private var content: some View {
        IdleSpaceView()
            .transition(.opacity)
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
