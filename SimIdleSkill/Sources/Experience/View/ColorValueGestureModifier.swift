//
//  ColorValueGestureModifier.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

/// A view modifier that adds value adjustment gestures to a view containing ColorCodeView
struct ColorValueGestureModifier: ViewModifier {
    // MARK: - Properties
    
    /// The selected value to modify
    @Binding private var value: Int
    
    /// Whether the gesture is active (component is selected)
    private var isActive: Bool
    
    /// Vertical padding for the gesture area
    private let verticalPadding: CGFloat
    
    // MARK: - Initialization
    
    /// Creates a new color value gesture modifier
    /// - Parameters:
    ///   - value: Binding to the value to modify (0-255)
    ///   - isActive: Whether the gesture should be active
    ///   - verticalPadding: The padding at the top and bottom of the gesture area
    init(
        value: Binding<Int>,
        isActive: Bool,
        verticalPadding: CGFloat
    ) {
        self._value = value
        self.isActive = isActive
        self.verticalPadding = verticalPadding
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            guard isActive else { return }
                            updateValueFromPosition(gesture.location.y, in: geometry.size)
                        }
                )
        }
    }
    
    // MARK: - Helper Methods
    
    /// Updates the value based on the touch position
    /// - Parameters:
    ///   - positionY: The y-position of the touch
    ///   - size: The size of the gesture area
    private func updateValueFromPosition(_ positionY: CGFloat, in size: CGSize) {
        // Adjust for padding
        let effectiveHeight = size.height - (verticalPadding * 2)
        
        // Calculate bounds for the gesture area
        let minY = verticalPadding
        let maxY = size.height - verticalPadding
        
        // Bound the position within the effective area
        let boundedY = max(minY, min(positionY, maxY))
        
        // Calculate the normalized position (0 to 1) where 0 is top (after padding)
        let normalizedPosition = (boundedY - minY) / effectiveHeight
        
        // Invert the value so top = 255, bottom = 0
        let invertedValue = 1.0 - normalizedPosition
        
        // Set the value (0-255)
        value = Int(round(invertedValue * 255))
    }
}

/// A view modifier that adjusts values based on drag distance
struct ColorValueDragModifier: ViewModifier {
    // MARK: - Properties

    /// The selected value to modify
    @Binding private var value: Int

    /// Whether the gesture is active
    private var isActive: Bool

    /// The minimum value
    private let minValue: Int

    /// The maximum value
    private let maxValue: Int

    /// How many points of drag distance equals one value change
    private let sensitivity: CGFloat

    /// Starting position for the drag
    @State private var startLocation: CGPoint?

    /// Initial value when drag started
    @State private var startValue: Int?

    // MARK: - Initialization

    /// Creates a new color value drag modifier
    /// - Parameters:
    ///   - value: Binding to the value to modify
    ///   - isActive: Whether the gesture should be active
    ///   - minValue: The minimum value
    ///   - maxValue: The maximum value
    ///   - sensitivity: How many points of drag distance equals one value change
    init(
        value: Binding<Int>,
        isActive: Bool,
        minValue: Int = 0,
        maxValue: Int = 255,
        sensitivity: CGFloat = 1.0
    ) {
        self._value = value
        self.isActive = isActive
        self.minValue = minValue
        self.maxValue = maxValue
        self.sensitivity = sensitivity
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        guard isActive else { return }

                        if startLocation == nil {
                            startLocation = gesture.startLocation
                            startValue = value
                        }

                        guard let startValue = startValue else { return }

                        // Calculate vertical drag distance (negative because up should increase value)
                        let dragDistance = -(gesture.location.y - gesture.startLocation.y)

                        // Calculate value change based on sensitivity
                        let valueChange = Int(dragDistance / sensitivity)

                        // Apply the change and clamp to min/max
                        let newValue = startValue + valueChange
                        value = max(minValue, min(maxValue, newValue))
                    }
                    .onEnded { _ in
                        startLocation = nil
                        startValue = nil
                    }
            )
    }
}

// MARK: - View Extension

extension View {
    /// Adds a gesture that adjusts a color value based on vertical position
    /// - Parameters:
    ///   - value: Binding to the value to modify (0-255)
    ///   - isActive: Whether the gesture should be active
    ///   - verticalPadding: The padding at the top and bottom of the gesture area
    /// - Returns: A modified view that responds to gestures
    func colorValueGesture(
        value: Binding<Int>,
        isActive: Bool,
        verticalPadding: CGFloat = 20
    ) -> some View {
        self.modifier(
            ColorValueGestureModifier(
                value: value,
                isActive: isActive,
                verticalPadding: verticalPadding
            )
        )
    }

    /// Adds a gesture that adjusts a value based on drag distance
    /// - Parameters:
    ///   - value: Binding to the value to modify
    ///   - isActive: Whether the gesture should be active
    ///   - minValue: The minimum value
    ///   - maxValue: The maximum value
    ///   - sensitivity: How many points of drag distance equals one value change
    /// - Returns: A modified view that responds to drag gestures
    func colorValueDrag(
        value: Binding<Int>,
        isActive: Bool,
        minValue: Int = 0,
        maxValue: Int = 255,
        sensitivity: CGFloat = 1.0
    ) -> some View {
        self.modifier(
            ColorValueDragModifier(
                value: value,
                isActive: isActive,
                minValue: minValue,
                maxValue: maxValue,
                sensitivity: sensitivity
            )
        )
    }
}
