//
//  ColorPalletView.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

struct ColorPalletView: View {
    @ObservedObject var colorStore: ColorStore
    @State private var isShowing = false
    @State private var selectedIndex: Int = 0
    @State private var deleteTargetIndex: Int?
    private let deletionSkillLogic: ColorPalletDeletionSkillLogic

    init(colorStore: ColorStore) {
        self.colorStore = colorStore
        self.deletionSkillLogic = ColorPalletDeletionSkillLogic(colorStore: colorStore)
        self._selectedIndex = State(initialValue: 0)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundArea
            contentContainer
        }
        .frame(height: 200)
        .onAppear {
            resetSelectedIndex()
        }
    }

    private var contentContainer: some View {
        VStack {
            Spacer()
            if let index = deleteTargetIndex {
                deleteConfirmation(for: index)
            }
            if isShowing {
                colorItems
            }
        }
        .frame(height: 120)
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
    }
    
    private var backgroundArea: some View {
        Rectangle()
            .fill(.clear)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                didTapBackground()
            }
    }
    
    private var colorItems: some View {
        HStack(spacing: 24) {
            ForEach(colorStore.colorPallets.reversed(), id: \.id) { pallet in
                let index = colorStore.colorPallets.firstIndex(where: { $0.id == pallet.id }) ?? 0
                colorItem(for: pallet.element, at: index)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: colorStore.colorPallets)
    }
    
    @ViewBuilder
    private func colorItem(for element: ColorElement, at index: Int) -> some View {
        ColorItemView(
            orbColor: element.orbColor,
            spaceColor: element.spaceColor,
            isSelected: selectedIndex == index
        )
        .onTapGesture {
            didSelectColor(at: index)
        }
        .onLongPressGesture {
            process(deletionEvent: .longTap(index: index))
        }
    }

    private func resetSelectedIndex() {
        selectedIndex = 0
    }
    
    private func didTapBackground() {
        if isShowing || deleteTargetIndex != nil {
            withAnimation(.easeOut(duration: 0.3)) {
                isShowing = false
                deleteTargetIndex = nil
            }
        } else {
            withAnimation(.easeIn(duration: 0.3)) {
                isShowing = true
            }
        }
    }
    
    private func didSelectColor(at index: Int) {
        withAnimation(.easeOut(duration: 0.55)) {
            colorStore.moveToFirst(at: index)
            selectedIndex = 0
        }
        deleteTargetIndex = nil
    }
    
    private func process(deletionEvent event: ColorPalletDeletionEvent) {
        let action = deletionSkillLogic.determineAction(for: event)
        let result = deletionSkillLogic.executeAction(action)
        
        switch result {
        case .success(let resultType):
            process(deletionSuccess: resultType)
        case .failure(let error):
            process(deletionFailure: error)
        }
    }
    
    private func process(deletionSuccess resultType: ColorPalletDeletionResultType) {
        switch resultType {
        case .deleteConfirmationRequested(let index):
            deleteTargetIndex = index
            
        case .deleted(let remainingCount):
            deleteTargetIndex = nil
            withAnimation(.easeInOut(duration: 0.3)) {
                if selectedIndex >= remainingCount {
                    selectedIndex = max(0, remainingCount - 1)
                }
            }
            
        case .deleteCancelled:
            deleteTargetIndex = nil
        }
    }
    
    private func process(deletionFailure error: ColorPalletDeletionError) {
        // Handle errors - could add logging or user feedback here
        deleteTargetIndex = nil
    }

    @ViewBuilder
    private func deleteConfirmation(for index: Int) -> some View {
        ColorPalletDeleteConfirmationView(orbColor: colorStore.colorPallets[index].orbColor) {
            process(deletionEvent: .deleteConfirmed(index: index))
        }
        .id(isShowing)
    }
}


private struct ColorItemView: View {
    let orbColor: Color
    let spaceColor: Color
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(spaceColor)
                .frame(width: 24, height: 24)
            Circle()
                .fill(orbColor)
                .frame(width: 16, height: 16)
        }
        .frame(width: 24, height: 24)
        .animation(.easeIn(duration: 0.55), value: isSelected)
        .contentShape(Circle())
        .allowsHitTesting(true)
    }
}

#Preview {
    ColorPalletView(
        colorStore: ColorStore()
    )
}
