
import Foundation

let stem = """
  _
 (_)
"""

let body = """
 .-'''''-.
/  /\\   /\\  \\
|          |
| /\\/\\/\\/\\ |
 \\________/
"""

let stemLines = stem.split(separator: "\n", omittingEmptySubsequences: false)
let bodyLines = body.split(separator: "\n", omittingEmptySubsequences: false)

let bodyWidth = bodyLines.map { $0.count }.max()!

var pumpkinLines: [String] = []

for line in stemLines {
    let padding = max((bodyWidth - line.count) / 2, 0)
    pumpkinLines.append(String(repeating: " ", count: padding) + line)
}

for line in bodyLines {
    pumpkinLines.append(String(line))
}

for line in pumpkinLines {
    print(line)
}
