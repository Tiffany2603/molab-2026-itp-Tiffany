// Week 01 — Part 2: Text Art
// Part 1 学习记录见同一文件夹中的 Part1_Learning_Record.md
// 使用了变量、函数和 for-loop。
// 卡点：1...5 包含 5；1..<5 不包含 5。

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
