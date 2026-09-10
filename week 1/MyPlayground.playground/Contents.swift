// Week 01 — Part 2: Generative Text Art
// Part 1 learning record: Part1_Learning_Record.md
// This pattern is generated with arrays, loops, conditions, and calculations.

let word = Array("TIFFANY")
let filledCharacter = "#"
let emptyCharacter = " "
let rows = 7
let columns = 5

func shouldFill(letter: Character, row: Int, column: Int) -> Bool {
    switch letter {
    case "T":
        return row == 0 || column == columns / 2
    case "I":
        return row == 0 || row == rows - 1 || column == columns / 2
    case "F":
        return row == 0 || row == rows / 2 || column == 0
    case "A":
        return (row == 0 && column > 0 && column < columns - 1)
            || row == rows / 2
            || (column == 0 && row > 0)
            || (column == columns - 1 && row > 0)
    case "N":
        return column == 0 || column == columns - 1 || column == row - 1
    case "Y":
        return (row < rows / 2 && (column == row || column == columns - 1 - row))
            || (row >= rows / 2 && column == columns / 2)
    default:
        return false
    }
}

func printWordPattern() {
    for row in 0..<rows {
        var line = ""

        for letter in word {
            for column in 0..<columns {
                if shouldFill(letter: letter, row: row, column: column) {
                    line += filledCharacter
                } else {
                    line += emptyCharacter
                }
            }

            line += "  "
        }

        print(line)
    }
}

print("Generated pattern: \(String(word))")
printWordPattern()
