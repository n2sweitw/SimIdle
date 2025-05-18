//
//  ColorCodeView.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

/// A view that displays RGB color code components with interactive selection
struct ColorCodeView: View {
    // MARK: - Types
    
    /// Represents the selected color component
    enum ColorComponent: CaseIterable {
        case none
        case red
        case green
        case blue
        
        /// Returns the starting position of this component in a hex string
        var hexStringOffset: Int {
            switch self {
            case .red: return 1
            case .green: return 3
            case .blue: return 5
            case .none: return 0 // Not used for hex string updates
            }
        }
    }
    
    // MARK: - Properties
    
    /// The current selected color component
    @Binding private var selectedComponent: ColorComponent
    
    /// The current value of the selected component
    @Binding private var selectedValue: Int
    
    /// The color hex string
    @Binding private var hexColor: String
    
    /// The text color for all components
    private let textColor: Color
    
    /// Computed RGB values from the hex string
    private var red: Int {
        Int(hexColor.dropFirst().prefix(2), radix: 16) ?? 0
    }
    
    private var green: Int {
        Int(hexColor.dropFirst(3).prefix(2), radix: 16) ?? 0
    }
    
    private var blue: Int {
        Int(hexColor.dropFirst(5).prefix(2), radix: 16) ?? 0
    }
    
    // MARK: - Initialization
    
    /// Creates a new ColorCodeView with the specified hex color and selected component
    /// - Parameters:
    ///   - hexColor: Binding to the hex color string (format: "#RRGGBB")
    ///   - selectedComponent: Binding to the currently selected component
    ///   - selectedValue: Binding to the value of the selected component (0-255)
    ///   - textColor: The color to use for all text components
    init(
        hexColor: Binding<String>,
        selectedComponent: Binding<ColorComponent>,
        selectedValue: Binding<Int>,
        textColor: Color
    ) {
        self._hexColor = hexColor
        self._selectedComponent = selectedComponent
        self._selectedValue = selectedValue
        self.textColor = textColor
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 0) {
            Text("#")
                .font(.title)
                .foregroundStyle(textColor.opacity(0.6))
            
            componentText(
                value: red,
                isSelected: selectedComponent == .red,
                component: .red
            )
            
            componentText(
                value: green,
                isSelected: selectedComponent == .green,
                component: .green
            )
            
            componentText(
                value: blue,
                isSelected: selectedComponent == .blue,
                component: .blue
            )
        }
        .font(.system(.body, design: .monospaced))
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.clear)
        .onChange(of: selectedValue) { oldValue, newValue in
            updateHexColor(from: oldValue, to: newValue)
        }
        // When selected component changes, update the selected value
        .onChange(of: selectedComponent) { oldComponent, newComponent in
            if oldComponent != newComponent {
                updateSelectedValueForComponent(newComponent)
            }
        }
    }
    
    // MARK: - Helper Views
    
    /// Creates a text view for a color component with appropriate styling and tap gesture
    /// - Parameters:
    ///   - value: The component value to display (0-255)
    ///   - isSelected: Whether this component is currently selected
    ///   - component: The color component
    /// - Returns: A styled Text view with tap gesture
    private func componentText(value: Int, isSelected: Bool, component: ColorComponent) -> some View {
        let displayValue = selectedComponent == component && selectedComponent != .none ? selectedValue : value
        
        return Text(String(format: "%02X", displayValue))
            .foregroundStyle(textColor)
            .font(.title)
            .fontWeight(isSelected ? .bold : .regular)
            .scaleEffect(isSelected ? 1.07 : 1.0)
            .contentShape(Rectangle())
            .onTapGesture {
                // Toggle selection: if already selected, deselect it
                selectedComponent = selectedComponent == component ? .none : component
            }
    }
    
    // MARK: - Helper Methods
    
    /// Updates the selected value to match the current component's value
    /// - Parameter component: The newly selected component
    private func updateSelectedValueForComponent(_ component: ColorComponent) {
        switch component {
        case .red:
            selectedValue = red
        case .green:
            selectedValue = green
        case .blue:
            selectedValue = blue
        case .none:
            // Do nothing when no component is selected
            break
        }
    }
    
    /// Updates the hex color string when the selected value changes
    /// - Parameters:
    ///   - oldValue: The previous selected value
    ///   - newValue: The new selected value
    private func updateHexColor(from oldValue: Int, to newValue: Int) {
        guard oldValue != newValue && selectedComponent != .none else { return }
        
        var newHex = hexColor
        let hexValue = String(format: "%02X", newValue)
        let offset = selectedComponent.hexStringOffset
        
        let startIndex = newHex.index(newHex.startIndex, offsetBy: offset)
        let endIndex = newHex.index(startIndex, offsetBy: 2)
        newHex.replaceSubrange(startIndex..<endIndex, with: hexValue)
        
        hexColor = newHex
    }
}

// MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @State private var selection = ColorCodeView.ColorComponent.none
        @State private var hexColor = "#FF8040"
        @State private var selectedValue = 0
        
        var body: some View {
            VStack(spacing: 20) {
                ColorCodeView(
                    hexColor: $hexColor,
                    selectedComponent: $selection,
                    selectedValue: $selectedValue,
                    textColor: .preset.defaultOrb
                )
                
                Text("Selected: \(selection == .none ? "None" : selection == .red ? "R" : selection == .green ? "G" : "B")")
                Text("Value: \(selectedValue)")
                Text("Hex Color: \(hexColor)")
                
                Slider(value: Binding(
                    get: { Double(selectedValue) },
                    set: { selectedValue = Int($0) }
                ), in: 0...255, step: 1)
                
                // Add extension to make preview work
                Rectangle()
                    .fill(Color(red: Double(Int(hexColor.dropFirst().prefix(2), radix: 16) ?? 0) / 255.0,
                                green: Double(Int(hexColor.dropFirst(3).prefix(2), radix: 16) ?? 0) / 255.0,
                                blue: Double(Int(hexColor.dropFirst(5).prefix(2), radix: 16) ?? 0) / 255.0))
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                
                HStack {
                    Button("None") {
                        selection = .none
                    }
                    Button("R") {
                        selection = .red
                    }
                    Button("G") {
                        selection = .green
                    }
                    Button("B") {
                        selection = .blue
                    }
                }
            }
            .padding()
            .background(Color.preset.defaultSpace)
        }
    }
    
    return PreviewWrapper()
}
