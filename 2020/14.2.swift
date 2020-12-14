import Foundation

// https://adventofcode.com/2020/day/14
let testInput = importPuzzleInput("./14.2.input.test.txt")
let input = importPuzzleInput("./14.input.txt")

var instructions = input.components(separatedBy: "\n")

let program = Program()

for instruction in instructions {
  let instructionComponents = instruction.components(separatedBy: " = ")
  if instruction.prefix(4) == "mask" {
    program.setMask(instructionComponents[1])
  }
  if instruction.prefix(3) == "mem" {
    let value = Int(instructionComponents[1])!
    let matches = instructionComponents[0].groups(for: "([0-9]+)")
    var memLoc = String(Int(matches[0][0])!, radix: 2)
    memLoc = pad(string: memLoc, toSize: 36)
    program.write(value: value, to: memLoc)
  }
}

print(program.sumMemory())

class Program {
  var mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  var memory = [UInt: Int]()
  var resolvedLocations = [String]()

  func setMask(_ mask: String) {
    self.mask = mask
  }

  func sumMemory() -> Int {
    var sum: Int = 0
    for (_, value) in self.memory {
      sum += value
    }
    return sum
  }

  func write(value: Int, to: String) {
    var maskedLocation = Array(to)
    for (index, bit) in self.mask.enumerated() {
      if bit == "1" {
        maskedLocation[index] = "1"
      } else if bit == "X" {
        maskedLocation[index] = "X"
      }
    }
    self.resolvedLocations.append(String(maskedLocation))
    self.resolveFloatingBit()


    for location in self.resolvedLocations {
      let decimalLocation = binaryToInt(binaryString: location)
      self.memory[decimalLocation] = value
    }
    self.resolvedLocations.removeAll()
  }

  func resolveFloatingBit() -> Void {
    for location in self.resolvedLocations {
      var resolvedLocation1 = Array(location)
      var resolvedLocation0 = Array(location)
      for (index, bit) in location.enumerated() {
        if bit == "X" {
          resolvedLocation1[index] = "1"
          resolvedLocation0[index] = "0"
          self.resolvedLocations.remove(at: self.resolvedLocations.firstIndex(of: location)!)
          self.resolvedLocations.append(String(resolvedLocation1))
          self.resolvedLocations.append(String(resolvedLocation0))
          self.resolveFloatingBit()
          return
        }
      }
    }
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