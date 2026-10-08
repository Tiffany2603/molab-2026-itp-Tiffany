# Study Timer Storage

A three-page SwiftUI app extending the Week04 timer. The Settings page saves a name with `@AppStorage`, and Home displays a greeting using that saved name.

## Run

1. Open `Study Timer Storage/Study Timer Storage.xcodeproj` in Xcode.
2. Select the `Study Timer Storage` scheme and an installed iPhone Simulator.
3. Click Run.

Minimum iOS version: 17. For a physical device, select a development team in Signing & Capabilities.

## Code

- `Study Timer Storage/Study Timer Storage/ContentView.swift` contains the pages and their logic (95 lines).
- `Study Timer Storage/Study Timer Storage/Study_Timer_StorageApp.swift` is the app entry point.
- `Learning_Record.md` contains the weekly notes and summary.

## Behavior

Open Settings from Home and enter a name. Changes are saved automatically. Return to Home to see the greeting; the saved name remains available after closing and reopening the app. An empty name displays `Hello!`.

The timer retains the Week04 controls. Only the name is saved; the timer's seconds and running state remain temporary.

## Build

iOS device-target compilation verified without code signing.
