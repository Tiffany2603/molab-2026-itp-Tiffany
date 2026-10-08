# Study Timer

A two-page SwiftUI app with a Home page and a Timer page. The timer supports Start, Pause, Resume, and Reset.

## Run

1. Open `Study Timer/Study Timer.xcodeproj` in Xcode.
2. Select the `Study Timer` scheme and an installed iPhone Simulator.
3. Click Run.

Minimum iOS version: 17. For a physical device, select a development team in Signing & Capabilities.

## Code

- `Study Timer/Study Timer/ContentView.swift` contains the pages and their logic (73 lines).
- `Study Timer/Study Timer/Study_TimerApp.swift` is the app entry point.
- `Learning_Record.md` contains the weekly notes and summary.

## Behavior

Open Timer from Home. Start begins counting seconds, Pause stops the count, Resume continues it, and Reset returns it to `00:00`. Leaving the timer page pauses it; a new visit starts a fresh timer.

The count uses temporary `@State` values and is not saved between app launches.

## Build

iOS device-target compilation verified without code signing.
