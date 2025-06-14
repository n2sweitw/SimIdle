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
                if currentSkill == .idleSpace {
                    colorPallet
                }
            }
        }
        .onReceive(colorStore.$colorPallets) { pallets in
            let colorElementSet = ColorElementSet(elements: pallets.map { ColorElement(orbHexCode: $0.orbHexCode, spaceHexCode: $0.spaceHexCode) })
            onColorUpdate?(colorElementSet.stringRepresentation)
        }
        .onAppear {
            updatePaletteIfNeeded()
        }
    }

    private var background: some View {
        Rectangle()
            .fill(colorStore.spaceColor)
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .multiTapGesture(
                onSingleTap: {
                    onBackgroundTap?()
                },
                onTwoFingerTap: {
                    withAnimation(.easeIn(duration: 0.3)) {
                        currentSkill = .help
                    }
                }
            )
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
        case .help:
            HelpView(
                onDismiss: {
                    withAnimation(.easeIn(duration: 0.3)) {
                        currentSkill = .idleSpace
                    }
                },
                orbColor: colorStore.orbColor,
                spaceColor: colorStore.spaceColor
            )
            .transition(.opacity)
        }
    }

    private var colorPallet: some View {
        ColorPalletView(
            colorStore: colorStore
        )
    }

    private func updatePaletteIfNeeded() {
        guard let receivedColorElementSet = receivedColorElementSet,
              !receivedColorElementSet.isEmpty else { return }
        
        let currentColorElementSet = ColorElementSet(elements: colorStore.colorPallets.map { ColorElement(orbHexCode: $0.orbHexCode, spaceHexCode: $0.spaceHexCode) })
        
        if currentColorElementSet.stringRepresentation != receivedColorElementSet {
            updatePalette(from: receivedColorElementSet)
        }
    }
    
    private func updatePalette(from colorElementSet: String) {
        let colorElementSetParsed = ColorElementSet(from: colorElementSet)
        colorStore.colorPallets = colorElementSetParsed.elements.map { ColorStore.ColorPallet(element: $0) }
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
