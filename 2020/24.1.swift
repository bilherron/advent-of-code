import Foundation

// https://adventofcode.com/2020/day/24
let input = importPuzzleInput("./24.input.txt")
let testInput = importPuzzleInput("./24.input.test.txt")

let test = false
let directions = (test) ? testInput.components(separatedBy: "\n") : input.components(separatedBy: "\n")
// let directions = """
// esew
// nwwswee
// """.components(separatedBy: "\n")

var floorGrid = [Tile]()
floorGrid.append(Tile(x: 0, y: 0, isBlack: false))

for direction in directions {
  let directionArray = parseDirections(direction)
  // print(directionArray)
  var x = 0, y = 0
  for instruction in directionArray {
    switch instruction {
      case "nw":
        x -= 1
        y -= 1
      case "ne":
        x += 1
        y -= 1
      case "sw":
        x -= 1
        y += 1
      case "se":
        x += 1
        y += 1
      case "w":
        x -= 2
        y += 0
      case "e":
        x += 2
        y += 0
      default:
        x += 0
        y += 0
    }
  }
  print(x, y)
    // print("trying to find", (x, y))
    // print(floorGrid)
  if floorGrid.contains(where: { $0.position == (x, y)}) {
    // print("found")
    let tileIndex = floorGrid.firstIndex(where: { $0.position == (x, y)})!
    floorGrid[tileIndex].turnOver()
  } else {
    floorGrid.append(Tile(x: x, y: y, isBlack: true))
  }
}
let blackCount = floorGrid.reduce(0, { (acc, tile) in
    print(tile)
    return tile.isBlack ? acc + 1 : acc
  })
print("directions", directions.count, "tiles", floorGrid.count)
print("Number of black tiles:", blackCount)

struct Tile {
  var position: (Int, Int)
  var isBlack: Bool = false // enum?

  init(x: Int, y: Int, isBlack: Bool) {
    self.position = (x, y)
    self.isBlack = isBlack
  }

  mutating func turnOver() -> Void {
    self.isBlack.toggle()
    print("flipping \(self.position) to \(self.isBlack)")
  }

}
func parseDirections(_ direction: String) -> [String] {
  var directionArray = [String]()
  var diag = ""
  for char in direction {
    let strChar = String(char)
    if diag.isEmpty {
      if char == "n" || char == "s" {
        diag = strChar
        continue
      } else {
        directionArray.append(strChar)
      }
    } else {
      directionArray.append(diag + strChar)
      diag = ""
    }
  }
  return directionArray
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