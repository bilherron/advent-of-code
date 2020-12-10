import Foundation

// https://adventofcode.com/2020/day/10
let input = importPuzzleInput("./10.input.txt")
// let input = importPuzzleInput("./10.input.test.2.txt")
var adapters = input.components(separatedBy: "\n").map { Int($0)! }

adapters.sort()

var currentJoltage = 0
var possibleAdapterPerms = [Decimal]()

while currentJoltage < adapters.max()! {
  let possibleAdapters = adapters.filter( { $0 == (currentJoltage + 1) || $0 == (currentJoltage + 2) || $0 == (currentJoltage + 3) } )
  if possibleAdapters.count > 0 {
    var permutations = pow(2, possibleAdapters.count) - 1
    for (index, possibleAdapter) in possibleAdapters.enumerated() {
      let indexOfPossibleAdapter = adapters.firstIndex(of: possibleAdapters[0])!
      let nextIndex = indexOfPossibleAdapter + possibleAdapters.count
      if (adapters.indices.contains(nextIndex) && (adapters[nextIndex] - possibleAdapter) > 3) {
        let adjustment =  possibleAdapters.count - (index + 1)
        permutations -= Decimal(adjustment)
      }
    }
    possibleAdapterPerms.append(permutations)
    currentJoltage = possibleAdapters.max()!
  } else {
    currentJoltage = adapters.max()!
  }
}

print(possibleAdapterPerms.reduce(1) { $0 * $1 })

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
