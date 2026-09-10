// Week 01 — Part 2: Text Art
// Part 1 learning record: Part1_Learning_Record.md
// This Playground demonstrates variables, functions, and a for-loop.
// Learning issue: 1...5 includes 5; 1..<5 does not include 5.

let title = "TIFFANY"
let lineSymbol = "-"
let lineLength = 51

func printLine(symbol: String, length: Int) {
    print(String(repeating: symbol, count: length))
}

func printTiffanyArt() {
    let art = [
        "TTTTT  III  FFFFF  FFFFF    A    N   N  Y   Y",
        "  T     I   F      F        A A   NN  N   Y Y ",
        "  T     I   F      F       A   A  N N N    Y  ",
        "  T     I   FFFF   FFFF    AAAAA  N  NN    Y  ",
        "  T     I   F      F       A   A  N   N    Y  ",
        "  T     I   F      F       A   A  N   N    Y  ",
        "  T    III  F      F       A   A  N   N    Y  "
    ]

    print(title)
    printLine(symbol: lineSymbol, length: lineLength)

    for row in art {
        print(row)
    }

    printLine(symbol: lineSymbol, length: lineLength)
}

printTiffanyArt()
