# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SimIdle is a minimalist iOS relaxation app that allows users to experience "idle time" through a simple visual interface. The core experience centers around a single animated orb that gently moves with spring-based physics, where users can customize both the background and orb colors to reflect their emotional state.

## Build Commands

This is an iOS app project built with Xcode and Swift Package Manager:

```bash
# Open the project in Xcode
open SimIdle.xcworkspace

# Build from command line (requires xcodebuild)
xcodebuild -workspace SimIdle.xcworkspace -scheme SimIdle -destination 'platform=iOS Simulator,name=iPhone 15' build

# Run tests
xcodebuild -workspace SimIdle.xcworkspace -scheme SimIdle -destination 'platform=iOS Simulator,name=iPhone 15' test

# Run specific test class
xcodebuild -workspace SimIdle.xcworkspace -scheme SimIdle -destination 'platform=iOS Simulator,name=iPhone 15' test -only-testing:SimIdleTests/SimIdleTests

# Run UI tests
xcodebuild -workspace SimIdle.xcworkspace -scheme SimIdle -destination 'platform=iOS Simulator,name=iPhone 15' test -only-testing:SimIdleUITests
```

### Testing Framework

- **Unit Tests**: Uses Swift Testing framework (with `@Test` and `@Suite` attributes)
- **UI Tests**: Uses XCTest framework
- **Assertions**: Use `#expect()` for Swift Testing, `XCTAssert*` for XCTest

## Architecture Overview

The codebase follows a modular architecture with strict separation between skill modules:

```
SimIdle/              # Main iOS app target
├── SimIdleApp.swift  # App entry point
└── Package.swift     # SimIdleKit package definition

SimIdleSkill/         # Skill modules package
├── Sources/
│   ├── App/          # SimIdleApp module - main app UI and skill registry
│   └── Experience/   # SimIdleExperience module - core idle experience
└── Package.swift
```

### Key Architectural Principles

1. **Module Independence**: Skill modules (Experience, App) have NO dependencies between them. Communication happens only through primitive types via parent module mediation.

2. **Value Semantics**: Strictly use structs and pure functions. Avoid classes except where required by SwiftUI/UIKit.

3. **Protocol-Oriented Programming**: Use protocols for abstraction, avoiding inheritance.

4. **Thread Safety**: Use Actor and Task for asynchronous contexts. All shared state must be thread-safe.

5. **Inter-Module Communication**: Communication between skill modules uses only Swift primitives (String, UUID, Int, Bool, Double, Data). Within modules, use proper type definitions.

### Color System Architecture

Colors in SimIdle are represented as 12-character hex strings combining orb and space colors:
- Format: `[orb_color_hex][space_color_hex]` (e.g., `3BB6A2FFF8E1`)
- ColorElement: Single color pair
- ColorElementSet: Up to 5 ColorElements (60 chars max)
- ColorStore: Manages persistence and state

### Skill Registry Pattern

Skills are registered through a protocol-based system:
- `SimIdleSkill` protocol defines skill interface
- `SkillRegistry` manages available skills
- Skills are self-contained with their own views and state

## Development Guidelines

### When Adding New Features

1. **New Skill Modules**: Create as separate targets in SimIdleSkill/Package.swift with no dependencies on other skill modules.

2. **Shared Code**: If multiple modules need similar code, copy it rather than creating shared dependencies. "Copy the hell out of it" philosophy.

3. **External Dependencies**: Use dependency inversion principle. Define protocols in the consuming module.

4. **State Management**: Use @State and @StateObject sparingly. Prefer value types and pure functions.

### Code Style Requirements

- Swift 6.1 compliance (Xcode project uses Swift 6.0, Package.swift specifies 6.1)
- iOS Deployment Target: 18.4 (Xcode project) / 18.0 (Package.swift)
- Single responsibility per type/function
- English-only comments explaining "why" not "what"
- Avoid abstract names (Manager, Handler, etc.)
- Follow SwiftUI best practices for view composition

## Design Principles

When modifying or extending this codebase, adhere to these principles:

1. **Minimalist UI**: Maximize whitespace, use only 2D representation (no shadows/3D)
2. **Limited Color Palette**: Restrict to two colors - orb and background
3. **Value Semantics**: Use structs and pure functions
4. **Protocol-Oriented**: Follow Protocol-Oriented Programming approach
5. **Single Responsibility**: Each type should have a single responsibility
6. **Open/Closed Principle (OCP)**: Classes/modules should be open for extension but closed for modification. Use protocols and extensions to add new functionality
7. **Thread Safety**: Ensure thread-safe design for asynchronous contexts
8. **Dependency Inversion**: For external dependencies
9. **Type-Safe Storage**: Use proper type definitions for data persistence within modules

## Project Configuration

- **Bundle Identifier**: com.n2sweitw.SimIdle
- **Supported Orientations**: Portrait and Portrait Upside Down only
- **Device Family**: iPhone and iPad

## Reference Documentation

When implementing features, follow the guidelines in these documents:

- `./doc/swift_implementation_charter.md` - Swift implementation standards and patterns
- `./doc/swift-moudle-charter.md` - Module design principles and separation rules
- `./doc/swift_naming_convention_charter.md` - Detailed Swift naming conventions and patterns
- `./doc/view_implementation_guidelines.md` - SwiftUI view structure and splitting guidelines
- `./doc/mobile-app-skill-tree-structure.md` - Skill categorization and development priorities
- `./doc/simidle_color_element_format.md` - Color system specifications and formats
