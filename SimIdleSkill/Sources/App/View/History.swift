//
//  History.swift
//  SimIdleApp
//
//  Copyright (c) 2025 Tadashi Kimura
//  SPDX-License-Identifier: MIT
//  Generated with support from Claude Code (Anthropic)
//

import SwiftUI

/// Protocol for types that can be stored as history elements
public protocol HistoryElement: Equatable {}

/// Generic history implementation for managing navigation stack
public class History<T: Equatable>: ObservableObject {
    @Published private var stack: [T]
    
    public var current: T? {
        stack.last
    }
    
    public var isEmpty: Bool {
        stack.isEmpty
    }
    
    public var count: Int {
        stack.count
    }
    
    public init() {
        self.stack = []
    }
    
    public init(initial: T) {
        self.stack = [initial]
    }
    
    public func push(_ value: T) {
        stack.append(value)
    }
    
    @discardableResult
    public func pop() -> T? {
        guard !stack.isEmpty else { return nil }
        return stack.removeLast()
    }
    
    public func reset() {
        stack.removeAll()
    }
    
    public func reset(to value: T) {
        stack = [value]
    }
    
    public func contains(_ value: T) -> Bool {
        stack.contains(value)
    }
}
