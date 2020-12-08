import Foundation

// https://adventofcode.com/2020/day/8
let input = importPuzzleInput("./8.input.txt")

class Program {
  var acc = 0
  var instructions = [String]()
  var infiniteLoopDetector = [Int]()
  var instructionLine = 0

  init(instructions: [String]) {
    self.instructions = instructions
  }

  func execute(_ instructionLine: Int) -> Int {
    let instructionComponents = self.instructions[instructionLine].components(separatedBy: " ")
    let operation = instructionComponents[0], argument = Int(instructionComponents[1])!
    self.infiniteLoopDetector.append(self.instructionLine);
    switch(operation) {
      case "acc":
        self.acc += argument
        self.instructionLine += 1
      case "nop":
        self.instructionLine += 1
      case "jmp":
        self.instructionLine += argument
      default:
        print(operation)
    }

    return self.instructionLine
  }

  func run() -> Void {
    self.acc = 0
    self.instructionLine = 0

    var nextInstruction = execute(0)
    while true {
      if self.infiniteLoopDetector.contains(nextInstruction) {
        print("Infinite loop detected, aborting: \(self.acc)")
        break
      }
      nextInstruction = execute(nextInstruction)
    }
  }
}

let instructions = input.components(separatedBy: "\n")
var program = Program(instructions: instructions)

program.run()




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