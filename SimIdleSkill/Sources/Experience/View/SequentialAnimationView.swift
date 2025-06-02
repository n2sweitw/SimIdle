//
//  SequentialAnimationView.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

// MARK: - Generic Step-based Animation System

protocol AnimationStep: CaseIterable, RawRepresentable, Equatable, Comparable where RawValue == Int {
    var next: Self? { get }
}

extension AnimationStep {
    var next: Self? {
        let allCases = Array(Self.allCases)
        guard let currentIndex = allCases.firstIndex(of: self) else { return nil }
        let nextIndex = currentIndex + 1
        return nextIndex < allCases.count ? allCases[nextIndex] : nil
    }
}

extension AnimationStep where Self: RawRepresentable, RawValue == Int {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

class AnimationSequence<Step: AnimationStep>: ObservableObject {
    @Published var currentStep: Step
    
    init(initialStep: Step) {
        self.currentStep = initialStep
    }
    
    func proceed() {
        withAnimation(.linear(duration: 0.25)) {
            if let nextStep = currentStep.next {
                currentStep = nextStep
            }
        }
    }
    
    func reset(to step: Step) {
        currentStep = step
    }
}
