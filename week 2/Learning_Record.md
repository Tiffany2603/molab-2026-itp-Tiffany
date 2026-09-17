# Week 02 Learning Record

Learning resource: Hacking with Swift — [100 Days of SwiftUI](https://www.hackingwithswift.com/100/swiftui)

Goal: Continue from Day 7 and complete Days 8–9, learning structs, properties, and methods, in preparation for this week's ASCII art Playground.

## Day 8: Structs, Part One

Studied how to create custom structs, computed properties, property observers (`didSet`/`willSet`), and custom initializers. Structs are similar to plain objects in JavaScript/p5.js, but Swift requires every stored property to have a type and usually an initial value before the struct can be used, and methods are declared with `func` inside the struct body. Computed properties — a property whose value is calculated through a getter instead of stored directly — were the trickiest part, since in p5.js I would normally just write a separate function instead of treating it like a property.

Study time: about 1.5 hours

## Day 9: Structs, Part Two

Studied access control (`private`), static properties and methods, and how structs behave as value types (each copy is independent, unlike objects in JavaScript which are reference types). The concept of "static" was familiar from other languages, but the difference between an instance property/method and a static one — and when to use `self` versus the type name — took some practice to get right. Also worked through the checkpoint exercise to reinforce these ideas.

Study time: about 1.5 hours

## Notes: Multi-line String Literals (`"""`)

Used triple-quoted strings (`"""..."""`) to write the ASCII art for `stem` and `body` in `MyPlayground.playground`.

A regular string (`"..."`) can only hold one line — a real line break has to be inserted manually as `\n`, which is hard to read and edit for something like ASCII art where every line and space matters. A multi-line string lets you type the text across several lines exactly as it should look when printed, and Swift stores it with the real line breaks included — no `\n` needed.

Two rules worth remembering: the opening `"""` must be followed immediately by a line break (nothing else on that line), and the indentation of the closing `"""` is stripped from every line, so the code itself can stay indented without adding extra leading spaces to the string content. A `"` can be typed directly inside a multi-line string without escaping, but `\` still needs to be written as `\\`, same as in a regular string.

## Issues

### Invalid escape sequence in string literal

While manually editing the pumpkin face's ASCII art in `MyPlayground.playground` (changing the eyes from `^ ^` to `/\ /\`), Xcode showed the error `Invalid escape sequence in literal`.

Cause: in Swift string literals, `\` starts an escape sequence (like `\n`, `\\`, `\(...)`). A single `\` followed by an unrecognized character (such as a space) is treated as an invalid escape. To display an actual backslash character in a string, it must be written as two backslashes `\\`.

Fix: replace every single `\` in the pattern with `\\`, for example:
```swift
/  /\\   /\\  \\
```

## Weekly Summary

Total study time: about 3 hours on structs (Days 8–9), plus the ASCII Text Art Playground, which used string operations (`split`, `map`, `max`), `for` loops, string interpolation, and multi-line string literals to combine two ASCII art pieces into a pumpkin. Next, I plan to study classes and how they compare to structs.
