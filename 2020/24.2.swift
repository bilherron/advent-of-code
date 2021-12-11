import Foundation

// https://adventofcode.com/2020/day/24
let input = importPuzzleInput("./24.input.txt")
let testInput = importPuzzleInput("./24.input.test.txt")

let test = true
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

  if floorGrid.contains(where: { $0.position == (x, y)}) {
    let tileIndex = floorGrid.firstIndex(where: { $0.position == (x, y)})!
    floorGrid[tileIndex].turnOver()
  } else {
    floorGrid.append(Tile(x: x, y: y, isBlack: true))
  }
}
// fill in floor
printFloor(floorGrid)
floorGrid = fillInFloor(floorGrid)
printFloor(floorGrid)
floorGrid = addNewOutsideRow(floorGrid)
print("")
printFloor(floorGrid)
print("")
// print("Number of black tiles:", countBlackTiles(floorGrid))

for day in 1...30 {
  // print("=============== day \(day) ===============")
  let switchTime = timeElapsedInSecondsWhenRunningCode() {
    floorGrid = dailyTileSwitch(floorGrid)
  }
  print("switchTime", switchTime)
  floorGrid = addNewOutsideRow(floorGrid)
  // printFloor(floorGrid)
  print("Day \(day) black tiles:", countBlackTiles(floorGrid))
}




func dailyTileSwitch(_ floorGrid: [Tile]) -> [Tile] {
  var newFloor = [Tile]()
  for tile in floorGrid {
    let adjacentPositions = getAdjacentPositions(tile.position)


    var adjacentBlackTiles = 0
    printTimeElapsedWhenRunningCode(title: "adjacentBlackTiles") {
    adjacentBlackTiles = adjacentPositions.reduce(0, { acc, tilePosition in

      if floorGrid.contains(where: { $0.position == tilePosition }) {
        let tileIndex = floorGrid.firstIndex(where: { $0.position == tilePosition })!
        let adjTile = floorGrid[tileIndex]
        return acc + (adjTile.isBlack ? 1 : 0)
      }

      return acc
    })
    }
    // print(tile, adjacentBlackTiles)

    var todaysTile = tile
    if (tile.isBlack && (adjacentBlackTiles == 0 || adjacentBlackTiles > 2)) ||
       (tile.isBlack != true && adjacentBlackTiles == 2) {
      // print("tile at \(tile.position) is \(tile.isBlack ? "black": "white") with \(adjacentBlackTiles) adjacent black tiles, flipping.")
      todaysTile.turnOver()
    }
    newFloor.append(todaysTile)
  }
  return newFloor
}









func printTimeElapsedWhenRunningCode(title:String, operation:()->()) {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    //print("\(title): \(timeElapsed) s.")
}

func timeElapsedInSecondsWhenRunningCode(operation: ()->()) -> Double {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    return Double(timeElapsed)
}


func fillInFloor(_ floor: [Tile]) -> [Tile] {
  var newFloor = [Tile]()
  var maxX = 0, minX = 0, maxY = 0, minY = 0
  for tile in floor {
    if tile.position.0 > maxX {
      maxX = tile.position.0
    }
    if tile.position.0 < minX {
      minX = tile.position.0
    }
    if tile.position.1 > maxY {
      maxY = tile.position.0
    }
    if tile.position.1 < minY {
      minY = tile.position.0
    }
  }
  let floorX = maxX + abs(minX) + 1
  let floorY = maxY + abs(minY) + 1

  for y in 0...floorY {
    for x in 0...floorX {
      if y % 2 == 0 && x % 2 == 0 {
        continue
      }
      if y % 2 != 0 && x % 2 != 0 {
        continue
      }
      let checkPosition = (x + minX, y + minY)
      if floor.contains(where: { $0.position == checkPosition }) != true {
        let newTile = Tile(x: x+minX, y: y+minY, isBlack: false)
        newFloor.append(newTile)
      }
    }
  }

  return newFloor + floor
}

func addNewOutsideRow(_ floor: [Tile]) -> [Tile] {
  var newFloor = floor
  var maxX = 0, minX = 0, maxY = 0, minY = 0
  for tile in floor {
    if tile.position.0 > maxX {
      maxX = tile.position.0
    }
    if tile.position.0 < minX {
      minX = tile.position.0
    }
    if tile.position.1 > maxY {
      maxY = tile.position.1
    }
    if tile.position.1 < minY {
      minY = tile.position.1
    }
  }
  let floorX = maxX + abs(minX)
  let floorY = maxY + abs(minY)

  // print("minX: \(minX), maxX: \(maxX), minY: \(minY), maxY: \(maxY), floorX: \(floorX), floorY: \(floorY)")

  // Top
  // printFloor(newFloor + floor)
  let topRowBlacks = floor.filter { $0.position.1 == minY && $0.isBlack }
  if topRowBlacks.count > 0 {
    // print("we need to add a top row")
    let configTop = floor.contains(where: { $0.position == (maxX, minY) })
    // print("configTop is \(configTop)")
    for x in 0...floorX {
      // print("y is \(y), minY is \(minY), floorY is \(floorY)")
      if configTop {
        if x % 2 == 0 {
          newFloor.append(Tile(x: x + minX, y: minY - 1, isBlack: false))
        } else {
          continue
        }
      } else {
        if x % 2 == 0 {
          continue
        } else {
          newFloor.append(Tile(x: x + minX, y: minY - 1, isBlack: false))
        }
      }
    }
  }


  // Bottom
  // printFloor(newFloor + floor)
  let botRow = floor.filter { $0.position.1 == maxY }
  let leftBottomX = botRow.reduce(0, { acc, tile in
    return tile.position.0 < acc ? tile.position.0 : acc
  } )
  // print("maxY: \(maxY) bottom row", botRow)
  let botRowBlacks = floor.filter { $0.position.1 == maxY && $0.isBlack }
  if botRowBlacks.count > 0 {
    // print("we need to add a bottom row")
    for x in 0...floorX {
      if leftBottomX != minX {
        if x % 2 != 0 {
          continue
        }
      } else {
        if x % 2 == 0 {
          continue
        }
      }
      newFloor.append(Tile(x: x + minX, y: maxY + 1, isBlack: false))
    }
  }


  // Left
  // printFloor(newFloor + floor)
  for tile in newFloor {
    if tile.position.0 > maxX {
      maxX = tile.position.0
    }
    if tile.position.0 < minX {
      minX = tile.position.0
    }
    if tile.position.1 > maxY {
      maxY = tile.position.1
    }
    if tile.position.1 < minY {
      minY = tile.position.1
    }
  }
  var newFloorY = maxY + abs(minY)


  let leftColBlacks = newFloor.filter { ($0.position.0 == minX || $0.position.0 == minX + 1) && $0.isBlack }
  if leftColBlacks.count > 0 {
    let checkTilePosition = (minX , minY)
    // print("we need to add a left column, checking \(checkTilePosition)")
    let configLeft = newFloor.contains(where: { $0.position == checkTilePosition })
    for y in 0...(newFloorY) {
      // print("y is \(y), minY is \(minY), floorY is \(floorY)")
      if configLeft {
        // print("tile found!")
        if y % 2 == 0 {
          newFloor.append(Tile(x: minX - 2, y: y + minY, isBlack: false))
        } else {
          newFloor.append(Tile(x: minX - 1, y: y + minY, isBlack: false))
        }
      } else {
        // print("tile not found")
        if y % 2 == 0 {
          newFloor.append(Tile(x: minX - 1, y: y + minY, isBlack: false))
        } else {
          newFloor.append(Tile(x: minX - 2, y: y + minY, isBlack: false))
        }
      }
    }
  }

  // newFloor += floor
  // printFloor(newFloor)
  for tile in newFloor {
    if tile.position.0 > maxX {
      maxX = tile.position.0
    }
    if tile.position.0 < minX {
      minX = tile.position.0
    }
    if tile.position.1 > maxY {
      maxY = tile.position.1
    }
    if tile.position.1 < minY {
      minY = tile.position.1
    }
  }
  newFloorY = maxY + abs(minY)

  let rightColBlacks = newFloor.filter { ($0.position.0 == maxX || $0.position.0 == maxX - 1) && $0.isBlack }
  if rightColBlacks.count > 0 {
    // print("we need to add a right column")
    let configRight = newFloor.contains(where: { $0.position == (maxX, minY) })
    // print("configRight is \(configRight)")
    for y in 0...(newFloorY) {
      // print("y is \(y), minY is \(minY), floorY is \(floorY)")
      if configRight {
        if y % 2 == 0 {
          newFloor.append(Tile(x: maxX + 2, y: y + minY, isBlack: false))
        } else {
          newFloor.append(Tile(x: maxX + 1, y: y + minY, isBlack: false))
        }
      } else {
        if y % 2 == 0 {
          newFloor.append(Tile(x: maxX + 1, y: y + minY, isBlack: false))
        } else {
          newFloor.append(Tile(x: maxX + 2, y: y + minY, isBlack: false))
        }
      }
    }
  }

  return newFloor
}


func getAdjacentPositions(_ position: (Int, Int)) -> [(Int, Int)] {
  var adjPositions = [(Int, Int)]()
  adjPositions.append((position.0 + 1, position.1 - 1))
  adjPositions.append((position.0 + 2, position.1))
  adjPositions.append((position.0 + 1, position.1 + 1))
  adjPositions.append((position.0 - 1, position.1 + 1))
  adjPositions.append((position.0 - 2, position.1))
  adjPositions.append((position.0 - 1, position.1 - 1))
  return adjPositions
}

func countBlackTiles(_ floorGrid: [Tile]) -> Int {
  let blackCount = floorGrid.reduce(0, { (acc, tile) in
      // print(tile)
      return tile.isBlack ? acc + 1 : acc
    })
  return blackCount
}

func printFloor(_ floor: [Tile]) -> Void {
  var maxX = 0, minX = 0, maxY = 0, minY = 0
  for tile in floor {
    if tile.position.0 > maxX {
      maxX = tile.position.0
    }
    if tile.position.0 < minX {
      minX = tile.position.0
    }
    if tile.position.1 > maxY {
      maxY = tile.position.1
    }
    if tile.position.1 < minY {
      minY = tile.position.1
    }
  }

  // print("minX: \(minX), maxX: \(maxX), minY: \(minY), maxY: \(maxY), floorX: \(floorX), floorY: \(floorY)")
  for y in minY...maxY {
    for x in minX...maxX {
      var printChar = " "
      // print("checking \((x, y))")
      if let ind = floor.firstIndex(where: { $0.position == (x, y) }) {
        let tileToPrint = floor[ind]
        if tileToPrint.position == (0, 0) {
          printChar = tileToPrint.isBlack ? "☆" : "★"
        } else {
          printChar = tileToPrint.isBlack ? "⬡" : "⬢"
        }
      }
      print(printChar, terminator: "")
    }
    print("")
  }
  print("----------------------------")
}

struct Tile {
  var position: (Int, Int)
  var isBlack: Bool = false // enum?

  init(x: Int, y: Int, isBlack: Bool) {
    self.position = (x, y)
    self.isBlack = isBlack
  }

  mutating func turnOver() -> Void {
    self.isBlack.toggle()
    // print("flipping \(self.position) to \(self.isBlack)")
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