import Foundation

// https://adventofcode.com/2020/day/14
let testInput = importPuzzleInput("./14.input.test.txt")
let input = importPuzzleInput("./14.input.txt")

var instructions = input.components(separatedBy: "\n")

let program = Program()

for instruction in instructions {
  let instructionComponents = instruction.components(separatedBy: " = ")
  if instruction.prefix(4) == "mask" {
    program.setMask(instructionComponents[1])
  }
  if instruction.prefix(3) == "mem" {
    var value = String(Int(instructionComponents[1])!, radix: 2)
    value = pad(string: value, toSize: 36)
    let matches = instructionComponents[0].groups(for: "([0-9]+)")
    let memLoc = Int(matches[0][0])!
    program.write(value: value, to: memLoc)
  }
}

print(program.sumMemory())

class Program {
  var mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  var memory = [Int: String]()

  func setMask(_ mask: String) {
    self.mask = mask
  }

  func sumMemory() -> UInt {
    var sum: UInt = 0
    for (_, value) in self.memory {
      sum += binaryToInt(binaryString: value)
    }
    return sum
  }

  func write(value: String, to: Int) {
    var maskedValue = Array(value)
    for (index, bit) in self.mask.enumerated() {
      if bit == "1" {
        maskedValue[index] = "1"
      } else if bit == "0" {
        maskedValue[index] = "0"
      }
    }
    self.memory[to] = String(maskedValue)
  }

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

/* Helper functions copy/pasted from Stack Overflow 😬 */

func pad(string : String, toSize: Int) -> String {
  var padded = string
  for _ in 0..<(toSize - string.count) {
    padded = "0" + padded
  }
    return padded
}

func binaryToInt(binaryString: String) -> UInt {
  return strtoul(binaryString, nil, 2)
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
extension String {
  func groups(for regexPattern: String) -> [[String]] {
    do {
      let text = self
      let regex = try NSRegularExpression(pattern: regexPattern)
      let matches = regex.matches(in: text,
                                  range: NSRange(text.startIndex..., in: text))
      return matches.map { match in
          return (0..<match.numberOfRanges).map {
            let rangeBounds = match.range(at: $0)
            guard let range = Range(rangeBounds, in: text) else {
              return ""
            }
            return String(text[range])
          }
      }
    } catch let error {
      print("invalid regex: \(error.localizedDescription)")
      return []
    }
  }
}