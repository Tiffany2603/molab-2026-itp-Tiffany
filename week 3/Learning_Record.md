# Week 03 Learning Record

Learning resources: [03-Canvas-Explore](https://github.com/molab-itp/03-Canvas-Explore) (10print example), Apple SwiftUI documentation

Goal: Start SwiftUI, understand how the 10print example works, and build a multi view SwiftUI app that displays an image made of random elements.


## Code Questions and Notes

### Views and files
- A SwiftUI view is a ***struct*** that conforms to ***View***. Its structure (views inside ***body***), style (modifiers like ***.padding()***), and logic (functions and variables) are all written together, more like a React component than separate HTML/CSS/JS files.
- Swift finds a view by its ***struct*** name, not by the file name. Several views can live in one file, and splitting them into separate files is mainly for organization.
- Multi view means more than one view the user can switch between, for example with a button, ***TabView***, or ***NavigationStack***.

### Error: ***cannot find 'ContentView' in scope***
After pasting the 10print code into ***ContentView.swift***, the build failed. The pasted code replaced ***struct ContentView*** with ***struct CanvasAnimView***, but ***Pattern\_TryApp.swift*** was still calling ***ContentView()***. Fix: rename the struct back to ***ContentView***, or call the new name in the App file.

### ***CGPoint***, ***CGSize***, and ***.zero***
***var*** is a Swift keyword, and ***loc*** and ***nsize*** are just variable names. ***CGPoint*** (x, y) and ***CGSize*** (width, height) come from Apple's Core Graphics framework, which is imported through SwiftUI. ***.zero*** is a property these types provide, and it equals ***(0, 0)***. ***var loc = CGPoint.zero*** and ***var nsize: CGSize = .zero*** are both valid: the second one writes the type first, so the type name can be left out on the right side (type inference).

### Custom colors
***Color(red:green:blue:)*** takes values from 0 to 1, not 0 to 255, so a 255-based value has to be divided by 255. SwiftUI has no built-in hex initializer, so hex colors like ***0xFF6B6B*** need a small ***extension Color***. For a palette with many colors, it is easiest to list them in an array and pick one with ***randomElement()***.

### Growing the pattern from the center
For each cell, calculate how far its center is from the center of the canvas, measured in cells, and draw one "ring" of cells per frame. ***max(dx, dy)*** gives square rings, and ***sqrt(dx² + dy²)*** gives round rings. Keeping the sign of ***dx*** and ***dy*** (no ***abs()***) shows which side of the center a cell is on.

### Drawing arcs
***path.addRelativeArc(center:radius:startAngle:delta:)*** draws part of a circle: ***startAngle*** is where it starts, and ***delta*** is how far it turns (90° = quarter circle, 180° = half circle). On screen, 0° points right and 90° points **down**, because the y axis goes down. This is the opposite of math class. Call ***path.move(to:)*** before each arc so separate arcs are not joined by a straight line.

### Switching views with a button
***@State private var showHalfArcs = false*** stores which view to show, and ***Button { showHalfArcs.toggle() }*** flips it. When a ***@State*** value changes, SwiftUI redraws the view, and ***if showHalfArcs { ... } else { ... }*** inside ***body*** decides which view appears.

### Changing color over time
Store the time each shape was created (***born: Date***). When drawing, compare it with the current time from ***TimelineView*** (***now.timeIntervalSince(p.born)***) and pick the color based on the age.

## What Confused Me

### Closures nested inside closures

The hardest part to read is how many layers of ***{ }*** are stacked inside each other. In one view there are:

```swift
var body: some View {                          // 1. computed property
  TimelineView(...) { timeline in              // 2. closure
    Canvas { context, size in                  // 3. closure inside a closure
      for row in 0..<nrows {                   // 4. loop
        for col in 0..<ncols {                 // 5. loop inside a loop
          if cellRing == ring {                // 6. condition
```

Every layer looks almost the same (***{ ... }***), so it is hard to tell which one is a closure, which is a loop, and which is an ***if***. With trailing closure syntax (Day 7), the closure is written after the parentheses, so ***TimelineView(...) { timeline in*** does not look like a function call. It was also hard to tell where ***timeline***, ***context***, and ***size*** come from: they are parameters that SwiftUI passes into each closure, and they are named before ***in***. What helped: reading from the outside in, and using Xcode's code folding and matching-bracket highlighting to see where each block ends.

### Too many symbols

Swift uses a lot of symbols, and each one means something different:

| Symbol | Where I saw it | Meaning |
|---|---|---|
| ***@*** | ***@State***, ***@main*** | An attribute that gives a property or type special behavior. ***@State*** means "redraw the view when this changes", and ***@main*** marks where the app starts |
| ***#*** | ***#Preview*** | A macro. It generates code for Xcode's preview |
| ***!*** | ***randomElement()!*** | Force unwrap: "I'm sure this optional is not nil" (it crashes if it is nil) |
| ***? :*** | ***showHalfArcs ? "Show Arcs" : "Show Half Arcs"*** | Ternary operator: if true use the first value, otherwise the second |
| ***\_*** | ***\_ = timeline.date***, ***func randomSlash(_ p: ...)*** | Means "ignore this": ignore the value, or leave out the parameter label when calling |
| ***..<*** | ***0..<nrows*** | Range from 0 up to but not including ***nrows*** |
| ***->*** | ***func randomArc(...) -> Path*** | What the function returns |
| ***.*** at the start | ***.zero***, ***.round***, ***.degrees(90)*** | Shorthand. The type name is left out because Swift already knows the type |
| ***in*** | ***{ context, size in*** | Separates closure parameters from the closure body |

The same symbol can mean different things in different places (***\_*** is used in two ways, and ***?*** is used for both optionals and the ternary operator), which makes it harder to guess when I see a symbol I haven't looked up yet.

## Weekly Summary

Study time: about 6 hours

This week I moved from Playgrounds to a real SwiftUI app project. I learned how an app is organized (App entry → views), how ***Canvas*** and ***TimelineView*** draw and animate shapes, and how ***@State*** and a ***Button*** switch between views. My project uses arrays, random numbers, loops, and functions from the Swift fundamentals I studied in Weeks 1–2. Next, I want to get more comfortable reading nested closures, look up the symbols I don't know yet, and try switching views with ***TabView***.
