//
//  ShareView.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

public struct ShareView: View {
    @State private var currentSkill: ShareSkill = .menu
    @State private var currentElement: ColorElement
    @State private var colorElementSet: ColorElementSet
    private var onComplete: (() -> Void)?
    private var onColorElementSetUpdate: ((String) -> Void)?

    public init(
        colorElementSet: String
    ) {
        let parsedColorElementSet = ColorElementSet(from: colorElementSet)
        let currentElement: ColorElement = parsedColorElementSet.elements.first ?? .init(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1")
        
        self._currentElement = State(initialValue: currentElement)
        self._colorElementSet = State(initialValue: parsedColorElementSet)
    }
    
    public var body: some View {
        contentView
            .animation(.easeInOut(duration: 0.3), value: currentSkill)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch currentSkill {
        case .menu:
            MenuView(
                currentView: $currentSkill,
                orbColor: currentElement.orbColor,
                backgroundColor: currentElement.spaceColor,
                onComplete: {
                    onComplete?()
                }
            )
        case .colorSharing:
            colorShareView
        case .colorReceiving:
            EmptyView()
        }
    }
    
    private var colorShareView: some View {
        ColorSharingView(
            elements: colorElementSet.elements,
            textColor: currentElement.orbColor,
            backgroundColor: currentElement.spaceColor
        )
        .onComplete {
            currentSkill = .menu
        }
    }
}

public extension ShareView {
    func onComplete(_ action: @escaping () -> Void) -> ShareView {
        var view = self
        view.onComplete = action
        return view
    }
    
    func onColorElementSetUpdate(_ action: @escaping (String) -> Void) -> ShareView {
        var view = self
        view.onColorElementSetUpdate = action
        return view
    }
}

#Preview {
    ShareView(
        colorElementSet: "3BB6A2FFF8E1"
    )
}
