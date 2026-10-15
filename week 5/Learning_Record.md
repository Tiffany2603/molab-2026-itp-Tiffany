# Week 05 Learning Record

## Swift Fundamentals — Days 10–14

Learning resource: [100 Days of SwiftUI](https://www.hackingwithswift.com/100/swiftui).

### Day 10: Structs, Computed Properties, and Property Observers

Source: [Day 10](https://www.hackingwithswift.com/100/swiftui/10)

A ***struct*** groups properties and methods, similar to an object in a p5.js sketch, but it has value semantics rather than JavaScript's object-reference behavior. A computed property calculates a value, like a function that converts seconds into minutes. ***didSet*** automatically runs code after a property changes; in a simple p5.js sketch, related updates are often written manually. ***init*** sets up an instance, and ***mutating*** marks methods that change a struct's state.

### Day 11: Access Control and Static Properties and Methods

Source: [Day 11](https://www.hackingwithswift.com/100/swiftui/11)

***private*** limits access to a property's implementation details. ***static*** makes a property or method belong to the type instead of one instance, similar to ***static*** members in a JavaScript class. The main distinction is between data belonging to each object and data belonging to the type. In the timer app, ***private*** keeps ***seconds*** inside its view.

### Day 12: Classes and Inheritance

Source: [Day 12](https://www.hackingwithswift.com/100/swiftui/12)

Swift classes are similar to JavaScript classes used in p5.js: ***init*** is comparable to ***constructor***, and ***self*** is similar to ***this***. Classes can inherit behavior, and assigning an instance to another variable shares the same object, as with JavaScript objects. A Swift ***let*** reference, like JavaScript ***const***, can still allow changes to the object's mutable properties. Structs instead have value semantics.

### Day 13: Protocols, Extensions, and Opaque Return Types

Source: [Day 13](https://www.hackingwithswift.com/100/swiftui/13)

A protocol specifies what properties or methods a type must provide. In a p5.js sketch, different objects might all have an ***update()*** method by convention; Swift can check such requirements through a protocol. An extension adds functionality to an existing type. In ***ContentView: View***, ***View*** is a protocol, not a superclass. ***some View*** lets Swift infer the concrete interface type while exposing its conformance to ***View***.

### Day 14: Optionals and Missing Values

Source: [Day 14](https://www.hackingwithswift.com/100/swiftui/14)

An optional such as ***String?*** can hold a value or ***nil***. This is similar to handling ***null*** or ***undefined*** in JavaScript, but Swift makes the possibility of missing data explicit in the type. ***if let*** and ***guard let*** safely unwrap values; ***??*** supplies a fallback, and ***?.*** accesses a value only when present, similar to JavaScript's operators. In the pattern app, ***randomElement()*** can return ***nil*** for an empty array, so force unwrapping with ***!*** needs care.

## Code Questions and Notes

### Adding a Settings page

The app extends the Week04 timer with a Settings page. It now has three pages: Home, Timer, and Settings. A second ***NavigationLink*** on Home opens ***SettingsView***.

### Saving a name with ***@AppStorage***

***@AppStorage("userName") private var userName = ""*** reads and saves a name using UserDefaults. The empty string is the default when no name has been saved. Unlike temporary ***@State*** values, this setting remains available after the app closes.

### Storage keys and variable names

The string ***"userName"*** is the storage key, while ***userName*** is the variable used in the code. Home and Settings each declare their own property using the same key, so they access the same saved value. The properties remain ***private***; neither view directly accesses the other view's variable.

### Binding an input field

***TextField("Enter your name", text: $userName)*** connects the input field to the name. ***userName*** reads the value, while ***$userName*** provides a binding that lets the field read and change it. Changes are saved through ***@AppStorage***, without a separate Save button.

### Updating the greeting

***userName.isEmpty*** checks whether the saved string is empty. Home displays ***Hello!*** for an empty name, or uses string interpolation to display a greeting such as ***Hello, Tiffany!***.

### Temporary state and saved settings

The timer still uses ***@State*** for ***seconds*** and ***isRunning***. Only the name is saved with ***@AppStorage***. This keeps a temporary timer session separate from a setting that should persist between app launches.

## Final Project Ideas

For my final project, I want to explore an app that takes advantage of what makes a phone different from a computer. I would like to start with two main aspects:

1. **Portability:** A phone can be carried around and used in different everyday situations.
2. **Sensor capabilities:** A phone can use its sensors to collect information and support practical tools.

I see these as two of the biggest differences between mobile and desktop experiences. One possible direction is a small everyday assistant app that uses phone sensors to provide useful tools for daily life.

## Weekly Summary

This week's project adds a local-storage feature to the Week04 navigation app. The Settings page edits a name, and Home displays the saved value. The project demonstrates how ***@AppStorage*** and a TextField binding work together, and how saved settings differ from temporary ***@State*** values. The final-project direction focuses on phone portability and sensor-based tools for daily life. The Days 10–14 notes connect structs, access control, classes, protocols, and optional handling to the existing SwiftUI code.
