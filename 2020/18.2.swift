import Foundation

// https://adventofcode.com/2020/day/18
let input = importPuzzleInput("./18.input.txt")
let equations = input.components(separatedBy: "\n")

var equation = ""
equation = "1 + 2 * 3 + 4 * 5 + 6" // 71
equation = "2 * 3 + (4 * 5)" // 46.
equation = "5 + (8 * 3 + 9 + 3 * 4 * 3)" // 1445.
equation = "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" // 669060.
equation = "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2" // 23340.

let sum = equations.reduce(0, { $0 + reduceParens($1) })
print("Sum: \(sum)")

func reduceParens(_ equation: String) -> Int {
  var newEquation = equation
  var openParenIndices = [Int]()
  var pairs = [(Int, Int)]()
  for (index, char) in equation.enumerated() {
    if char == "(" {
      openParenIndices.append(index)
    }
    if char == ")" {
      pairs.append((openParenIndices.removeLast(), index))
    }
  }

  if pairs.isEmpty {
    return newMath(equation)
  }

  for pair in pairs {
    let parenRange = (pair.0 + 1)..<pair.1
    let subEq = equation[parenRange]
    if subEq.firstIndex(of: "(") == nil {
      let subEqAnswer = newMath(subEq)
      newEquation = newEquation.replacingOccurrences(of: "(\(subEq))", with: String(subEqAnswer))
    }
  }

  return reduceParens(newEquation)
}

func newMath(_ equation: String) -> Int {
  let parts = equation.components(separatedBy: " * ")
  var nums = [Int]()
  // add
  for part in parts {
    let toAdd = part.components(separatedBy: " + ").map { Int($0)! }
    let num = toAdd.reduce(0, +)
    nums.append(num)
  }
  // then multiply
  let product = nums.reduce(1, *)

  return product
}

func importPuzzleInput(_ path: String) -> String {
  var input = ""
  do {
    input = try String(contentsOfFile: path, encoding: .utf8)
  }
  catch let error {
    print(error)
  }
  return input
}

extension String {
  var length: Int {
    return count
  }

  subscript (i: Int) -> String {
    return self[i ..< i + 1]
  }

  func substring(fromIndex: Int) -> String {
    return self[min(fromIndex, length) ..< length]
  }

  func substring(toIndex: Int) -> String {
    return self[0 ..< max(0, toIndex)]
  }

  subscript (r: Range<Int>) -> String {
    let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                        upper: min(length, max(0, r.upperBound))))
    let start = index(startIndex, offsetBy: range.lowerBound)
    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
    return String(self[start ..< end])
  }
}