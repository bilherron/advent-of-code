import Foundation

// https://adventofcode.com/2020/day/10
let input = importPuzzleInput("./10.input.txt")
// let input = importPuzzleInput("./10.input.test.txt")
var adapters = input.components(separatedBy: "\n").map { Int($0)! }

adapters.sort()

var currentJoltage = 0

var diffCounts = [ 1: 0, 2: 0, 3: 0 ]

for adapter in adapters {
  let adapterDiff = adapter - currentJoltage
  currentJoltage = adapter
  diffCounts[adapterDiff]! += 1
}
diffCounts[3]! += 1
print(diffCounts[1]! * diffCounts[3]!)

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