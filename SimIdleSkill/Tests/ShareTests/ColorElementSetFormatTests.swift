//
//  SimIdleShareTests.swift
//  SimIdleShareTests
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Testing
@testable import SimIdleShare

struct ColorElementSetFormatTests {
    
    // MARK: - Single ColorElement Format Tests
    
    @Test("Single ColorElement generates 12-character hex string")
    func singleColorElementFormat() {
        let element = ColorElement(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1")
        let set = ColorElementSet(elements: [element])
        let result = set.stringRepresentation
        
        #expect(result == "3BB6A2FFF8E1")
        #expect(result.count == 12)
    }
    
    @Test("ColorElement without # prefix generates correct format")
    func colorElementWithoutHashPrefix() {
        let element = ColorElement(orbHexCode: "3BB6A2", spaceHexCode: "FFF8E1")
        let set = ColorElementSet(elements: [element])
        let result = set.stringRepresentation
        
        #expect(result == "3BB6A2FFF8E1")
        #expect(result.count == 12)
    }
    
    @Test("ColorElement with mixed case generates correct format")
    func colorElementMixedCase() {
        let element = ColorElement(orbHexCode: "#3bb6a2", spaceHexCode: "#FFF8e1")
        let set = ColorElementSet(elements: [element])
        let result = set.stringRepresentation
        
        #expect(result == "3bb6a2FFF8e1")
        #expect(result.count == 12)
    }
    
    // MARK: - Multiple ColorElements Format Tests
    
    @Test("Three ColorElements generate 36-character hex string")
    func multipleColorElementsFormat() {
        let elements = [
            ColorElement(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1"),
            ColorElement(orbHexCode: "#EDA3A8", spaceHexCode: "#F5FFF8"),
            ColorElement(orbHexCode: "#4A4A4A", spaceHexCode: "#F8F8F5")
        ]
        let set = ColorElementSet(elements: elements)
        let result = set.stringRepresentation
        
        #expect(result == "3BB6A2FFF8E1EDA3A8F5FFF84A4A4AF8F8F5")
        #expect(result.count == 36)
    }
    
    @Test("Maximum 5 ColorElements generate 60-character hex string")
    func maximumColorElementsFormat() {
        let elements = [
            ColorElement(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1"),
            ColorElement(orbHexCode: "#EDA3A8", spaceHexCode: "#F5FFF8"),
            ColorElement(orbHexCode: "#4A4A4A", spaceHexCode: "#F8F8F5"),
            ColorElement(orbHexCode: "#A9B0B8", spaceHexCode: "#1E2633"),
            ColorElement(orbHexCode: "#FF6B6B", spaceHexCode: "#FFFFFF")
        ]
        let set = ColorElementSet(elements: elements)
        let result = set.stringRepresentation
        
        #expect(result == "3BB6A2FFF8E1EDA3A8F5FFF84A4A4AF8F8F5A9B0B81E2633FF6B6BFFFFFF")
        #expect(result.count == 60)
    }
    
    // MARK: - Empty ColorElementSet Tests
    
    @Test("Empty ColorElementSet generates empty string")
    func emptyColorElementSet() {
        let set = ColorElementSet(elements: [])
        let result = set.stringRepresentation
        
        #expect(result == "")
        #expect(result.count == 0)
    }
    
    // MARK: - Format Parsing Tests
    
    @Test("Valid 12-character string parses to single ColorElement")
    func validSingleElementStringParsing() {
        let input = "3BB6A2FFF8E1"
        let set = ColorElementSet(from: input)
        
        #expect(set.elements.count == 1)
        #expect(set.elements[0].orbHexCode == "#3BB6A2")
        #expect(set.elements[0].spaceHexCode == "#FFF8E1")
    }
    
    @Test("Valid 36-character string parses to three ColorElements")
    func validMultipleElementsStringParsing() {
        let input = "3BB6A2FFF8E1EDA3A8F5FFF84A4A4AF8F8F5"
        let set = ColorElementSet(from: input)
        
        #expect(set.elements.count == 3)
        #expect(set.elements[0].orbHexCode == "#3BB6A2")
        #expect(set.elements[0].spaceHexCode == "#FFF8E1")
        #expect(set.elements[1].orbHexCode == "#EDA3A8")
        #expect(set.elements[1].spaceHexCode == "#F5FFF8")
        #expect(set.elements[2].orbHexCode == "#4A4A4A")
        #expect(set.elements[2].spaceHexCode == "#F8F8F5")
    }
    
    @Test("Invalid length string parses to empty ColorElementSet")
    func invalidLengthStringParsing() {
        let input = "3BB6A2FFF8E" // 11 characters
        let set = ColorElementSet(from: input)
        
        #expect(set.elements.count == 0)
    }
    
    @Test("Partial valid string parses only complete elements")
    func partialValidStringParsing() {
        let input = "3BB6A2FFF8E1EDA3A8F5FFF8ABC" // 27 characters (2 complete + 3 incomplete)
        let set = ColorElementSet(from: input)
        
        #expect(set.elements.count == 2)
        #expect(set.elements[0].orbHexCode == "#3BB6A2")
        #expect(set.elements[0].spaceHexCode == "#FFF8E1")
        #expect(set.elements[1].orbHexCode == "#EDA3A8")
        #expect(set.elements[1].spaceHexCode == "#F5FFF8")
    }
    
    // MARK: - Round-trip Tests
    
    @Test("Round-trip conversion maintains format integrity")
    func roundTripConversion() {
        let originalElements = [
            ColorElement(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1"),
            ColorElement(orbHexCode: "#EDA3A8", spaceHexCode: "#F5FFF8")
        ]
        let originalSet = ColorElementSet(elements: originalElements)
        let stringRepresentation = originalSet.stringRepresentation
        let parsedSet = ColorElementSet(from: stringRepresentation)
        
        #expect(parsedSet.elements.count == originalElements.count)
        #expect(parsedSet.elements[0].orbHexCode == "#3BB6A2")
        #expect(parsedSet.elements[0].spaceHexCode == "#FFF8E1")
        #expect(parsedSet.elements[1].orbHexCode == "#EDA3A8")
        #expect(parsedSet.elements[1].spaceHexCode == "#F5FFF8")
    }
    
    // MARK: - Static Method Tests
    
    @Test("Static colorCodesString method generates correct format")
    func staticColorCodesStringMethod() {
        let elements = [
            ColorElement(orbHexCode: "#3BB6A2", spaceHexCode: "#FFF8E1"),
            ColorElement(orbHexCode: "#EDA3A8", spaceHexCode: "#F5FFF8")
        ]
        let result = ColorElementSet.colorCodesString(from: elements)
        
        #expect(result == "3BB6A2FFF8E1EDA3A8F5FFF8")
        #expect(result.count == 24)
    }
}
