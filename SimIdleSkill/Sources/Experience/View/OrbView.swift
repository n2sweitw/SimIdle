//
//  OrbView.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import UIKit
import SwiftUI

final class UIKitOrbView: UIView {
    var orbColor: UIColor {
        get { orbView.orbColor }
        set { orbView.orbColor = newValue }
    }
    var onTap: (() -> Void)?
    private let orbView: OrbShapeView
    private var animationTask: Task<Void, Never>?
    private let animationInterval: TimeInterval
    
    init(
        orbColor: UIColor,
        animationInterval: TimeInterval = 6.0,
        onTap: (() -> Void)? = nil
    ) {
        self.animationInterval = animationInterval
        self.orbView = OrbShapeView(color: orbColor)
        self.onTap = onTap

        super.init(frame: .zero)

        self.backgroundColor = .clear
        setupOrbView()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupOrbView() {
        orbView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        addSubview(orbView)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        orbView.addGestureRecognizer(tapGesture)
        orbView.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        onTap?()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let orbFrame = orbView.frame
        if orbFrame.contains(point) {
            return super.hitTest(point, with: event)
        }
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let centerX = bounds.midX
        let centerY = bounds.midY
        let offset = RandomOffset()

        orbView.center = CGPoint(
            x: centerX + offset.horizontal,
            y: centerY + offset.vertical
        )
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            startAnimation()
        } else {
            stopAnimation()
        }
    }
    
    private func startAnimation() {
        let animationInterval = animationInterval
        animationTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(animationInterval))
                if !Task.isCancelled {
                    await MainActor.run {
                        animateToRandomPosition()
                    }
                }
            }
        }
    }

    private func stopAnimation() {
        animationTask?.cancel()
        animationTask = nil
    }
    
    private func animateToRandomPosition() {
        let centerX = bounds.midX
        let centerY = bounds.midY
        let offset = RandomOffset()

        let targetPoint = CGPoint(
            x: centerX + offset.horizontal,
            y: centerY + offset.vertical
        )

        let animator = UIViewPropertyAnimator(duration: 3.5, dampingRatio: 0.6) { [weak self] in
            self?.orbView.center = targetPoint
        }

        animator.startAnimation()
    }
}

extension UIKitOrbView {
    private final class OrbShapeView: UIView {
        var orbColor: UIColor {
            get {
                guard let cgColor = orbLayer.fillColor else { return .clear }
                return UIColor(cgColor: cgColor)
            }
            set {
                orbLayer.fillColor = newValue.cgColor
            }
        }

        private let orbLayer: CAShapeLayer

        init(color: UIColor) {
            self.orbLayer = CAShapeLayer()
            super.init(frame: .zero)
            setupLayer(color: color)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupLayer(color: UIColor) {
            let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 50, height: 50))
            orbLayer.path = circlePath.cgPath
            orbLayer.fillColor = color.cgColor
            orbLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            layer.addSublayer(orbLayer)
        }
    }

    struct RandomOffset {
        let vertical: CGFloat
        let horizontal: CGFloat

        init() {
            vertical = CGFloat.random(in: -10...10)
            horizontal = CGFloat.random(in: -20...20)
        }
    }
}

// SwiftUI wrapper
struct OrbView: UIViewRepresentable {
    private let orbColor: UIColor
    private let animationInterval: TimeInterval
    private let onTap: (() -> Void)?
    
    init(
        orbColor: Color,
        animationInterval: TimeInterval = 6.0,
        onTap: (() -> Void)? = nil
    ) {
        self.orbColor = UIColor(orbColor)
        self.animationInterval = animationInterval
        self.onTap = onTap
    }
    
    func makeUIView(context: Context) -> UIKitOrbView {
        UIKitOrbView(
            orbColor: orbColor,
            animationInterval: animationInterval,
            onTap: onTap
        )
    }   
    
    func updateUIView(_ uiView: UIKitOrbView, context: Context) {
        uiView.orbColor = orbColor
        uiView.onTap = onTap
    }
}

#Preview {
    OrbView(
        orbColor: Color("circleColor")
    )
}
