//
//  ColorStore.swift
//  SimIdleExperience
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

/// ColorStore manages color preferences using UserDefaults
class ColorStore: ObservableObject {
    private enum Keys {
        static let orbHexCode = "orbHexCode"
        static let spaceHexCode = "spaceHexCode"
        static let palletPrefix = "colorPallet_"
    }

    /// Color preset configuration
    struct ColorPallet: Codable, Identifiable, Equatable {
        var id = UUID()
        var element: ColorElement

        var orbHexCode: String {
            element.orbHexCode
        }

        var spaceHexCode: String {
            element.spaceHexCode
        }

        var orbColor: Color {
            element.orbColor
        }

        var spaceColor: Color {
            element.spaceColor
        }

        init(element: ColorElement) {
            self.element = element
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
            let orbHexCode = try container.decode(String.self, forKey: .orbHexCode)
            let spaceHexCode = try container.decode(String.self, forKey: .spaceHexCode)
            element = ColorElement(orbHexCode: orbHexCode, spaceHexCode: spaceHexCode)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(element.orbHexCode, forKey: .orbHexCode)
            try container.encode(element.spaceHexCode, forKey: .spaceHexCode)
        }

        private enum CodingKeys: String, CodingKey {
            case id, orbHexCode, spaceHexCode
        }
    }

    let maxPallets = 5

    @Published var colorPallets: [ColorPallet] = []

    var orbHexCode: String {
        colorPallets.first?.orbHexCode ?? Color.preset.defaultOrbHex
    }

    var spaceHexCode: String {
        colorPallets.first?.spaceHexCode ?? Color.preset.defaultSpacedHex
    }

    var currentTheme: ColorElement {
        if let firstPallet = colorPallets.first {
            return firstPallet.element
        } else {
            return Color.preset.defaultColor
        }
    }
    
    var orbColor: Color {
        currentTheme.orbColor
    }

    var spaceColor: Color {
        currentTheme.spaceColor
    }

    init() {
        loadColorPallets()

        if colorPallets.isEmpty {
            setupDefaultPallets()
        }
    }

    private func setupDefaultPallets() {
        colorPallets = Color.preset.palette.map { element in
            ColorPallet(element: element)
        }
        saveColorPallets()
    }
    
    func resetToDefaults() {
        let defaultPallet = ColorPallet(element: Color.preset.defaultColor)
        colorPallets.removeAll()
        colorPallets.append(defaultPallet)
        saveColorPallets()
    }
    
    // MARK: - methods for color pallets

    func addColorsToPallet(element: ColorElement) {
        let newPallet = ColorPallet(element: element)

        if colorPallets.count >= maxPallets {
            colorPallets.removeLast()
        }

        colorPallets.insert(newPallet, at: 0)
        saveColorPallets()
    }

    func applyPallet(_ pallet: ColorPallet) {
        if let index = colorPallets.firstIndex(where: { $0.id == pallet.id }) {
            let selectedPallet = colorPallets.remove(at: index)
            colorPallets.insert(selectedPallet, at: 0)
            saveColorPallets()
        }
    }

    func moveToFirst(at index: Int) {
        guard index != 0 else { return }
        let selectedPallet = colorPallets.remove(at: index)
        colorPallets.insert(selectedPallet, at: 0)
        saveColorPallets()
    }

    func removePallet(at index: Int) {
        guard index >= 0 && index < colorPallets.count else { return }
        colorPallets.remove(at: index)
        saveColorPallets()
    }

    func hasMatchingPallet(element: ColorElement) -> Bool {
        return colorPallets.contains { pallet in
            pallet.element == element
        }
    }

    func updateCurrentColors(element: ColorElement) {
        if colorPallets.isEmpty {
            let newPallet = ColorPallet(element: element)
            colorPallets.append(newPallet)
        } else {
            colorPallets[0] = ColorPallet(element: element)
        }
        saveColorPallets()
    }

    // MARK: - Private methods

    private func saveColorPallets() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(colorPallets) {
            UserDefaults.standard.set(data, forKey: Keys.palletPrefix + "data")
        }
    }

    private func loadColorPallets() {
        guard let data = UserDefaults.standard.data(forKey: Keys.palletPrefix + "data") else {
            return
        }

        let decoder = JSONDecoder()
        if let pallets = try? decoder.decode([ColorPallet].self, from: data) {
            self.colorPallets = pallets
        }
    }
}
