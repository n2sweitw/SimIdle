//
//  MultiTapGestureView.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI
import UIKit

struct MultiTapGestureView: UIViewRepresentable {
    let onSingleTap: () -> Void
    let onTwoFingerTap: (() -> Void)?
    let size: CGSize
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Single tap gesture (always added)
        let singleTapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSingleTap))
        singleTapGesture.numberOfTouchesRequired = 1
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.delegate = context.coordinator
        view.addGestureRecognizer(singleTapGesture)
        
        // Two finger tap gesture (optional)
        if context.coordinator.onTwoFingerTap != nil {
            let twoFingerTapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTwoFingerTap))
            twoFingerTapGesture.numberOfTouchesRequired = 2
            twoFingerTapGesture.numberOfTapsRequired = 1
            twoFingerTapGesture.delegate = context.coordinator
            view.addGestureRecognizer(twoFingerTapGesture)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.frame = CGRect(origin: .zero, size: size)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onSingleTap: onSingleTap, onTwoFingerTap: onTwoFingerTap)
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        let onSingleTap: () -> Void
        let onTwoFingerTap: (() -> Void)?
        
        init(onSingleTap: @escaping () -> Void, onTwoFingerTap: (() -> Void)?) {
            self.onSingleTap = onSingleTap
            self.onTwoFingerTap = onTwoFingerTap
        }
        
        @objc func handleSingleTap() {
            onSingleTap()
        }
        
        @objc func handleTwoFingerTap() {
            onTwoFingerTap?()
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            return true
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}