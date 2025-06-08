//
//  ColorImportSkillLogic.swift
//  SimIdleShare
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import Foundation

/// Manages color import workflow and business logic
/// 
/// This SkillLogic encapsulates the decision-making process for color import operations,
/// specifically handling duplicate filtering and maximum color limit validation.
struct ColorImportSkillLogic {
    private let maxElements: Int
    
    init(maxElements: Int = 5) {
        self.maxElements = maxElements
    }
    
    /// Determines the appropriate action for color import events
    func determineAction(for event: ColorImportEvent) -> ColorImportAction {
        switch event {
        case .importRequested(let existingElements, let importedElements):
            return determineImportAction(existingElements: existingElements, importedElements: importedElements)
        }
    }
    
    /// Executes the color import action
    func executeAction(_ action: ColorImportAction) -> ColorImportResult {
        switch action {
        case .importColors(let filteredElements):
            return .success(.imported(filteredElements: filteredElements))
            
        case .rejectImport(let reason):
            return .success(.importRejected(reason: reason))
        }
    }
    
    /// Determines the appropriate import action based on filtering rules
    private func determineImportAction(existingElements: [ColorElement], importedElements: [ColorElement]) -> ColorImportAction {
        // Check if palette is already full
        if existingElements.count >= maxElements {
            return .rejectImport(reason: .paletteFull)
        }
        
        let filteredElements = filterOutExistingColors(existingElements: existingElements, importedElements: importedElements)
        
        // Check if all colors were filtered out (all duplicates)
        if filteredElements.isEmpty {
            return .rejectImport(reason: .allColorsAlreadyExist)
        }
        
        // Check if import count exceeds maximum allowed per import operation
        if filteredElements.count > maxElements {
            return .rejectImport(reason: .tooManyColorsAfterFiltering(maxAllowed: maxElements))
        }
        
        return .importColors(filteredElements: filteredElements)
    }
    
    /// Filters out colors that already exist in the palette
    private func filterOutExistingColors(existingElements: [ColorElement], importedElements: [ColorElement]) -> [ColorElement] {
        let existingColorCodes = Set(existingElements.map { $0.colorCode })
        return importedElements.filter { !existingColorCodes.contains($0.colorCode) }
    }
}

enum ColorImportEvent: Equatable {
    case importRequested(existingElements: [ColorElement], importedElements: [ColorElement])
}

enum ColorImportAction: Equatable {
    case importColors(filteredElements: [ColorElement])
    case rejectImport(reason: ImportRejectionReason)
}

enum ColorImportResult: Equatable {
    case success(ColorImportResultType)
    case failure(ColorImportError)
}

enum ColorImportResultType: Equatable {
    case imported(filteredElements: [ColorElement])
    case importRejected(reason: ImportRejectionReason)
}

enum ColorImportError: Equatable {
    case invalidState
}

enum ImportRejectionReason: Equatable {
    case allColorsAlreadyExist
    case tooManyColorsAfterFiltering(maxAllowed: Int)
    case paletteFull
}
