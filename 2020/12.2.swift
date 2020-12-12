import Foundation

// https://adventofcode.com/2020/day/12
let input = importPuzzleInput("./12.input.txt")
// let input = importPuzzleInput("./12.input.test.txt")
var directions = input.components(separatedBy: "\n")


class Ship {
  var bearing = "E" // enum?
  var position = (x: 0, y: 0)
  var waypoint = (x: 10, y: -1)

  func move(by: Int) -> Void{
    let moveX = self.waypoint.x * by
    let moveY = self.waypoint.y * by

    self.position.x += moveX
    self.position.y += moveY
  }

  func moveWaypoint(_ direction: String, by: Int) -> Void {
    var moveBy = by
    if direction == "N" || direction == "W" {
      moveBy = -(by)
    }
    if direction == "N" || direction == "S" {
      self.waypoint.y += moveBy
    }
    if direction == "E" || direction == "W" {
      self.waypoint.x += moveBy
    }
  }

  func rotateWaypoint(to: String, by: Int) -> Void {
    if (by == 270 && to == "R") {
      return self.rotateWaypoint(to: "L", by: 90)
    }
    if (by == 270 && to == "L") {
      return self.rotateWaypoint(to: "R", by: 90)
    }
    switch(by) {
      case 90:
        if to == "R" {
          self.waypoint = (-self.waypoint.y, self.waypoint.x)
        } else {
          self.waypoint = (self.waypoint.y, -self.waypoint.x)
        }
      case 180:
        self.waypoint = (-self.waypoint.x, -self.waypoint.y)
      default:
        print("Unhandled rotation")
    }
  }

}

let ferry = Ship()

for direction in directions {
  let action = String(direction.prefix(1))
  let value = Int(direction.suffix((direction.count - 1)))!

  if action == "L" || action == "R" {
    ferry.rotateWaypoint(to: action, by: value)
  } else if action == "F" {
    ferry.move(by: value)
  } else {
    ferry.moveWaypoint(action, by: value)
  }
}
// part 2
print(abs(ferry.position.x) + abs(ferry.position.y))

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