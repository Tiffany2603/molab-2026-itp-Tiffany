# Week 04 Learning Record

Learning resources: [Week04 — Swift UI 2, Audio](https://github.com/molab-itp/content-2026-itp/blob/main/weeks/04_swiftui.md), [05-TimerDemo](https://github.com/molab-itp/05-TimerDemo), [03-ImageUiDemo-1-symbols](https://github.com/molab-itp/03-ImageUiDemo-1-symbols)

Goal: Build a SwiftUI app with at least two pages and a time-based feature.

Project: **Study Timer**

## Code Questions and Notes

### Pages and navigation

The app has a Home page and a Timer page. `NavigationStack` contains the navigation, and `NavigationLink` opens `TimerView`. The two views are defined in `ContentView.swift`; the App entry file starts the app by displaying `ContentView()`.

### Temporary state with `@State`

`seconds` stores the elapsed count, and `isRunning` stores whether the count should increase. Both use `@State`, so changes update the interface. These values belong to the timer page and are not saved after the app closes.

### Receiving timer events

`Timer.publish(every: 1, on: .main, in: .common).autoconnect()` sends an event every second. `.onReceive(timer)` handles the event. The `if isRunning` condition decides whether to add one to `seconds`. Pausing changes the flag to `false`, so incoming events no longer increase the count.

### Start, Pause, Resume, and Reset

The main button uses `.toggle()` to switch `isRunning` between `true` and `false`. Its label uses conditional expressions to show Start, Pause, or Resume. Reset sets `seconds` to zero and `isRunning` to `false`. Leaving the timer page also pauses it.

### Displaying minutes and seconds

Integer division (`seconds / 60`) gives complete minutes, and the remainder (`seconds % 60`) gives the seconds left over. `String(format: "%02d:%02d", ...)` adds leading zeros, so 65 seconds is displayed as `01:05`.

## Weekly Summary

This week's project is a two-page SwiftUI timer app with navigation and Start, Pause, Resume, and Reset controls. It connects changing `@State` values to the interface and uses a condition inside `.onReceive` to control a time-based feature. The timer is a simple seconds counter; its state lasts for the current timer page.
