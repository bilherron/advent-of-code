import Foundation

// https://adventofcode.com/2020/day/13
let testInput = importPuzzleInput("./13.input.test.txt")
let input = importPuzzleInput("./13.input.txt")

var notes = input.components(separatedBy: "\n")
let earliestDeparture = Int(notes[0])!
let buses = notes[1].replacingOccurrences(of: "x,", with: "").components(separatedBy: ",").map { Int($0)! }

var shortestWait = 10000
var answer = 0
for bus in buses {
  var acc = bus
  while acc < earliestDeparture {
    acc += bus
  }
  let wait = acc - earliestDeparture
  if wait < shortestWait {
    shortestWait = wait
    answer = shortestWait * bus
  }
}
print(answer)
// 3rd



// class Ship {
//   var bearing = "E"
//   var position = (0,0)

//   func changeBearing(to: String, by: Int) -> Void {
//     switch(by) {
//       case 90:
//         if self.bearing == "N" {
//           if to == "L" {
//             self.bearing = "W"
//           } else {
//             self.bearing = "E"
//           }
//         } else if self.bearing == "S" {
//           if to == "L" {
//             self.bearing = "E"
//           } else {
//             self.bearing = "W"
//           }
//         } else if self.bearing == "E" {
//           if to == "L" {
//             self.bearing = "N"
//           } else {
//             self.bearing = "S"
//           }
//         } else if self.bearing == "W" {
//           if to == "L" {
//             self.bearing = "S"
//           } else {
//             self.bearing = "N"
//           }
//         }
//       case 180:
//         if self.bearing == "N" {
//           self.bearing = "S"
//         } else if self.bearing == "S" {
//           self.bearing = "N"
//         } else if self.bearing == "E" {
//           self.bearing = "W"
//         } else if self.bearing == "W" {
//           self.bearing = "E"
//         }
//       case 270:
//         if self.bearing == "N" {
//           if to == "L" {
//             self.bearing = "E"
//           } else {
//             self.bearing = "W"
//           }
//         } else if self.bearing == "S" {
//           if to == "L" {
//             self.bearing = "W"
//           } else {
//             self.bearing = "E"
//           }
//         } else if self.bearing == "E" {
//           if to == "L" {
//             self.bearing = "S"
//           } else {
//             self.bearing = "N"
//           }
//         } else if self.bearing == "W" {
//           if to == "L" {
//             self.bearing = "N"
//           } else {
//             self.bearing = "S"
//           }
//         }
//       default:
//         print("Unhandled rotation")
//     }
//   }

//   func move(_ direction: String, by: Int) -> Void{
//     var moveBy = by
//     if direction == "N" || direction == "W" {
//       moveBy = -(by)
//     }
//     if direction == "N" || direction == "S" {
//       self.position.1 += moveBy
//     }
//     if direction == "E" || direction == "W" {
//       self.position.0 += moveBy
//     }
//   }
// }

// var ferry = Ship()
// print(ferry.position)
// for direction in directions {
//   var action = String(direction.prefix(1))
//   let value = Int(direction.suffix((direction.count - 1)))!

//   if action == "L" || action == "R" {
//     ferry.changeBearing(to: action, by: value)
//   } else {
//     if action == "F" {
//       action = ferry.bearing
//     }
//     ferry.move(action, by: value)
//   }
// }
// // part 1
// print(abs(ferry.position.0) + abs(ferry.position.1))
// // 757 6th

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