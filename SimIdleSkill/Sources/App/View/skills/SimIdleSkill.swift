//
//  SimIdleSkill.swift
//  SimIdleApp
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//

import Foundation

/// Available skills in the SimIdle application
enum SimIdleSkill: String, Equatable, HistoryElement, Skill {
    case experience
    case share

    var id: String {
        rawValue
    }

    static func from(id: String) -> SimIdleSkill? {
        .init(rawValue: id)
    }
}
