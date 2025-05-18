//
//  ColorSelectionView.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct ColorSelectionView: View {
    @Binding var currentSkill: ExperienceSkill
    @ObservedObject var colorStore: ColorStore
    @StateObject private var session: ColorEditingSession
    
    init(currentSkill: Binding<ExperienceSkill>, colorStore: ColorStore) {
        self._currentSkill = currentSkill
        self.colorStore = colorStore
        self._session = StateObject(wrappedValue: ColorEditingSession(
            orbHexCode: colorStore.orbHexCode,
            spaceHexCode: colorStore.spaceHexCode
        ))
    }
    
    var body: some View {
        ZStack {
            backgroundView
            contentView
        }
        .onChange(of: session.orbColor.selection) { oldValue, newValue in
            orbSelectionChanged(from: oldValue, to: newValue)
        }
        .onChange(of: session.spaceColor.selection) { oldValue, newValue in
            backgroundSelectionChanged(from: oldValue, to: newValue)
        }
        .colorValueDrag(
            value: Binding(
                get: { session.activeValue },
                set: { session.updateActiveValue($0) }
            ),
            isActive: session.isOrbColorSelected || session.isSpaceColorSelected,
            minValue: 0,
            maxValue: 255,
            sensitivity: 9.0
        )
    }
    
    private var backgroundView: some View {
        Rectangle()
            .fill(session.spaceColor.color)
            .ignoresSafeArea()
    }
    
    private var contentView: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                orb
                
                VStack(spacing: 4) {
                    ColorCodeView(
                        hexColor: $session.orbColor.code,
                        selectedComponent: $session.orbColor.selection,
                        selectedValue: $session.orbColor.value,
                        textColor: session.orbColor.color
                    )
                    
                    ColorCodeView(
                        hexColor: $session.spaceColor.code,
                        selectedComponent: $session.spaceColor.selection,
                        selectedValue: $session.spaceColor.value,
                        textColor: session.orbColor.color
                    )
                }
            }
            
            Spacer()
            
            controls
                .padding(.bottom, 40)
        }
    }
    
    private var orb: some View {
        Circle()
            .fill(session.orbColor.color)
            .frame(width: 50, height: 50)
    }
    
    private var controls: some View {
        ColorSelectionControls(
            session: session,
            colorStore: colorStore,
            textColor: session.orbColor.color
        )
        .onEvent(processControlEvent)
    }
    
    // MARK: - Actions
    
    private func orbSelectionChanged(from oldValue: ColorCodeView.ColorComponent, to newValue: ColorCodeView.ColorComponent) {
        if oldValue == .none && newValue != .none {
            session.spaceColor.selectComponent(.none)
        }
    }
    
    private func backgroundSelectionChanged(from oldValue: ColorCodeView.ColorComponent, to newValue: ColorCodeView.ColorComponent) {
        if oldValue == .none && newValue != .none {
            session.orbColor.selectComponent(.none)
        }
    }
    
    private func processControlEvent(_ event: ColorSelectionEvent) {
        let skillLogic = ColorSelectionSkillLogic(colorStore: colorStore)
        
        switch event {
        case .reset:
            _ = skillLogic.executeAction(.reset, with: session)
        case .back:
            navigateBack()
        case .apply:
            _ = skillLogic.executeAction(.apply, with: session)
            navigateBack()
        case .add:
            _ = skillLogic.executeAction(.add, with: session)
            navigateBack()
        }
    }
    
    private func navigateBack() {
        withAnimation(.easeOut(duration: 0.3)) {
            currentSkill = .idleSpace
        }
    }
}

#Preview {
    @Previewable @State var skill: ExperienceSkill = .colorSelection
    ColorSelectionView(
        currentSkill: $skill,
        colorStore: ColorStore()
    )
}
