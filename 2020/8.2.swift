import Foundation

// https://adventofcode.com/2020/day/8
let input = importPuzzleInput("./8.input.txt")

class Program {
  var accumulator = 0
  var instructions = [String](), originalInstructions = [String]()
  var infiniteLoopDetector = [Int]()
  var instructionLine = 0
  var branchingPoints = [(Int, Int, Int, [Int], String)]()
  var attempted = [Int]()
  
  init(instructions: [String]) {
    self.instructions = instructions
    self.originalInstructions = instructions
  }
  
  func execute(_ instructionLine: Int) -> Int {
    let instructionComponents = self.instructions[instructionLine].components(separatedBy: " ")
    let operation = instructionComponents[0], argument = Int(instructionComponents[1])!
    var lineMovement = 0
    switch(operation) {
      case "acc":
        self.accumulator += argument
        lineMovement = 1
      case "nop":
        if !self.attempted.contains(self.instructionLine) {
          self.branchingPoints.append((instructionLine, self.instructionLine, self.accumulator, self.infiniteLoopDetector, "jmp \(instructionComponents[1])"))
        }
        lineMovement = 1
      case "jmp":
        if !self.attempted.contains(self.instructionLine) {
          self.branchingPoints.append((instructionLine, self.instructionLine, self.accumulator, self.infiniteLoopDetector, "nop \(instructionComponents[1])"))
        }
        lineMovement = argument
      default:
        print(operation)
    }
    self.infiniteLoopDetector.append(self.instructionLine);
    self.instructionLine += lineMovement
    return self.instructionLine
  }

  func run() -> Void {
    self.accumulator = 0
    self.instructionLine = 0

    var nextInstruction = execute(0)
    var newInstruction = ""
    while true {
      if self.infiniteLoopDetector.contains(nextInstruction) {
        print("Infinite loop detected, retrying...")
        (nextInstruction, self.instructionLine, self.accumulator, self.infiniteLoopDetector, newInstruction) = self.branchingPoints.removeFirst()
        self.attempted.append(self.instructionLine)
        self.instructions = self.originalInstructions
        self.instructions[nextInstruction] = newInstruction
      }
      if nextInstruction == instructions.count {
        print("Program complete: \(self.accumulator)")
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