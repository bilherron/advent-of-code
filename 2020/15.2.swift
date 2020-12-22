import Foundation

// https://adventofcode.com/2020/day/15

var input: String
input = "0,3,6" // 436.
// input = "1,3,2" // 1.
// input = "2,1,3" // 10.
// input = "1,2,3" // 27.
// input = "2,3,1" // 78.
// input = "3,2,1" // 438.
// input = "3,1,2" // 1836.
input = "2,20,0,4,1,17"

let inputArray = input.components(separatedBy: ",").map { String($0) }

var memory = [ String: (ult: Int, penult: Int) ]()
var lastSpoke = ""

for (index, number) in inputArray.enumerated() {
  memory[number] = (ult: index + 1, penult: 0)
  lastSpoke = number
}

let nextTurn = inputArray.count + 1
  var pctDone = 1
for turn in nextTurn...30000000 {
  let turnInt = Int(turn)
  if turnInt % 300000 == 0 {
    print("\(pctDone)% done")
    pctDone += 1
  }
  var nextSpoke = 0
  if memory.keys.contains(lastSpoke) && memory[lastSpoke]!.penult > 0 {
    nextSpoke = (memory[lastSpoke]!.ult - memory[lastSpoke]!.penult)
  } else {
    nextSpoke = 0
  }
  lastSpoke = String(nextSpoke)
  let penultimate = memory[lastSpoke]?.ult ?? 0
  memory[lastSpoke] = (ult: turnInt, penult: penultimate)
}

print(lastSpoke)