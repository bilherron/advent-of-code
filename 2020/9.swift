import Foundation

// https://adventofcode.com/2020/day/9
let input = importPuzzleInput("./9.input.txt")
// let input = importPuzzleInput("./9.input.test.txt")
var totalSet = input.components(separatedBy: "\n").map { Int($0)! }
let candidateSetSize = 25
var candidateSetStart = 0
var checkIndex = candidateSetSize
var invalidNumber = -1

while checkIndex < totalSet.count {
  let candidateSetEnd = candidateSetStart + candidateSetSize
  let candidateSet = totalSet[candidateSetStart..<candidateSetEnd]
  let check = Int(totalSet[checkIndex])
  for i in 0...candidateSet.count - 1 {
    let remaining = check - candidateSet[i+candidateSetStart]
    if remaining != check && candidateSet.contains(remaining) {
      candidateSetStart += 1
      checkIndex += 1
      break
    } else if i == (candidateSet.count - 1) {
      invalidNumber = check
      checkIndex = totalSet.count
    }
  }
}
// part 1
print("First invalid number: \(invalidNumber)")

var accumulator = invalidNumber
var largest = -1
var smallest = 1_000_000_000_000
var testing = -1
var i = 0

while i < totalSet.count {
  if testing < 0 {
    testing = i
  }
  if totalSet[i] >= invalidNumber {
    accumulator = invalidNumber
    largest = -1
    testing = -1
    smallest = 1_000_000_000_000
    i += 1
    continue
  }
  if totalSet[i] > largest {
    largest = totalSet[i]
  }
  if totalSet[i] < smallest {
    smallest = totalSet[i]
  }
  accumulator -= totalSet[i]
  if accumulator == 0 {
    i = totalSet.count
    continue
  }
  if accumulator < 0 {
    // reset
    accumulator = invalidNumber
    largest = -1
    smallest = 1_000_000_000_000
    i = testing + 1
    testing = -1
  } else {
    i += 1
  }
}
print("Encryption weakness: \(smallest + largest)")

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