# Week 05 Learning Record

Learning resources: [Week05 — Local Data 1, Sensors](https://github.com/molab-itp/content-2026-itp/blob/main/weeks/05_data.md), [05-AppStorageDemo](https://github.com/molab-itp/05-AppStorageDemo)

Goal: Incorporate a class-demo feature into the navigation app and use local storage for simple user data.

Project: **Study Timer Storage**

## Code Questions and Notes

### Adding a Settings page

The app extends the Week04 timer with a Settings page. It now has three pages: Home, Timer, and Settings. A second `NavigationLink` on Home opens `SettingsView`.

### Saving a name with `@AppStorage`

`@AppStorage("userName") private var userName = ""` reads and saves a name using UserDefaults. The empty string is the default when no name has been saved. Unlike temporary `@State` values, this setting remains available after the app closes.

### Storage keys and variable names

The string `"userName"` is the storage key, while `userName` is the variable used in the code. Home and Settings each declare their own property using the same key, so they access the same saved value. The properties remain `private`; neither view directly accesses the other view's variable.

### Binding an input field

`TextField("Enter your name", text: $userName)` connects the input field to the name. `userName` reads the value, while `$userName` provides a binding that lets the field read and change it. Changes are saved through `@AppStorage`, without a separate Save button.

### Updating the greeting

`userName.isEmpty` checks whether the saved string is empty. Home displays `Hello!` for an empty name, or uses string interpolation to display a greeting such as `Hello, Tiffany!`.

### Temporary state and saved settings

The timer still uses `@State` for `seconds` and `isRunning`. Only the name is saved with `@AppStorage`. This keeps a temporary timer session separate from a setting that should persist between app launches.

## Final Project Ideas

For my final project, I want to explore an app that takes advantage of what makes a phone different from a computer. I would like to start with two main aspects:

1. **Portability:** A phone can be carried around and used in different everyday situations.
2. **Sensor capabilities:** A phone can use its sensors to collect information and support practical tools.

I see these as two of the biggest differences between mobile and desktop experiences. One possible direction is a small everyday assistant app that uses phone sensors to provide useful tools for daily life.

## Weekly Summary

This week's project adds a local-storage feature to the Week04 navigation app. The Settings page edits a name, and Home displays the saved value. The project demonstrates how `@AppStorage` and a TextField binding work together, and how saved settings differ from temporary `@State` values. The final-project direction focuses on phone portability and sensor-based tools for daily life.
