//
//  ColorSelectionControls.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

enum ColorSelectionEvent {
    case reset
    case add
    case apply
    case back
}

struct ColorSelectionControls: View {
    @ObservedObject var session: ColorEditingSession
    let colorStore: ColorStore
    let textColor: Color
    private var onEvent: ((ColorSelectionEvent) -> Void)?
    private let skillLogic: ColorSelectionSkillLogic
    
    private var currentAction: ColorSelectionAction {
        skillLogic.determineAction(for: session)
    }
    
    init(session: ColorEditingSession, colorStore: ColorStore, textColor: Color) {
        self.session = session
        self.colorStore = colorStore
        self.textColor = textColor
        self.onEvent = nil
        self.skillLogic = ColorSelectionSkillLogic(colorStore: colorStore)
    }
    
    func onEvent(_ handler: @escaping (ColorSelectionEvent) -> Void) -> ColorSelectionControls {
        var controls = self
        controls.onEvent = handler
        return controls
    }
    
    var body: some View {
        HStack {
            Button(action: { onEvent?(.reset) }) {
                Text("[ Reset ]")
                    .foregroundStyle(textColor)
            }
            
            switch currentAction {
            case .add:
                Button(action: { onEvent?(.add) }) {
                    Text("[ Add ]")
                        .foregroundStyle(textColor)
                }
            case .apply:
                Button(action: { onEvent?(.apply) }) {
                    Text("[ Apply ]")
                        .foregroundStyle(textColor)
                }
            case .back:
                Button(action: { onEvent?(.back) }) {
                    Text("[ Back ]")
                        .foregroundStyle(textColor)
                }
            case .reset:
                Button(action: { onEvent?(.back) }) {
                    Text("[ Back ]")
                        .foregroundStyle(textColor)
                }
            }
        }
    }
}
