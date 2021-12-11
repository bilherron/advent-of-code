import Foundation

// https://adventofcode.com/2020/day/24
let input = importPuzzleInput("./24.input.txt")
let testInput = importPuzzleInput("./24.input.test.txt")

let test = false
let directions = (test) ? testInput.components(separatedBy: "\n") : input.components(separatedBy: "\n")

var floorGrid = [String: Tile]()
floorGrid["0,0"] = (Tile(x: 0, y: 0, isBlack: false))

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

  if floorGrid["\(x),\(y)"] != nil {
    floorGrid["\(x),\(y)"]!.turnOver()
  } else {
    floorGrid["\(x),\(y)"] = Tile(x: x, y: y, isBlack: true)
  }
}
// fill in floor
// printFloor(floorGrid)
floorGrid = fillInFloor(floorGrid)
// printFloor(floorGrid)
floorGrid = addNewOutsideRow(floorGrid)
// print("")
// printFloor(floorGrid)
// print("")
// print("Number of black tiles:", countBlackTiles(floorGrid))

for _ in 1...100 {
  // print("=============== day \(day) ===============")
  floorGrid = dailyTileSwitch(floorGrid)
  floorGrid = addNewOutsideRow(floorGrid)
  // printFloor(floorGrid)
  // print("Day \(day) black tiles:", countBlackTiles(floorGrid))
}
print("Number of black tiles:", countBlackTiles(floorGrid))
printFloor(floorGrid)



func dailyTileSwitch(_ floorGrid: [String: Tile]) -> [String: Tile] {
  var newFloor = [String: Tile]()
  for spot in floorGrid {
    let tile = spot.value
    let adjacentPositions = getAdjacentPositions(tile.position)

    let adjacentBlackTiles = adjacentPositions.reduce(0, { acc, tilePosition in
      let x = tilePosition.0, y = tilePosition.1
      if floorGrid["\(x),\(y)"] != nil {
        let adjTile = floorGrid["\(x),\(y)"]!
        return acc + (adjTile.isBlack ? 1 : 0)
      }

      return acc
    })

    // print(tile, adjacentBlackTiles)

    var todaysTile = tile
    if (tile.isBlack && (adjacentBlackTiles == 0 || adjacentBlackTiles > 2)) ||
       (tile.isBlack != true && adjacentBlackTiles == 2) {
      // print("tile at \(tile.position) is \(tile.isBlack ? "black": "white") with \(adjacentBlackTiles) adjacent black tiles, flipping.")
      todaysTile.turnOver()
    }
    newFloor["\(todaysTile.position.0),\(todaysTile.position.1)"] = todaysTile
  }
  return newFloor
}








func fillInFloor(_ floor: [String: Tile]) -> [String: Tile] {
  // printFloor(floor)
  var newFloor = [String: Tile]()
  var maxX = 0, minX = 0, maxY = 0, minY = 0
  for tile in floor {
    if tile.value.position.0 > maxX {
      maxX = tile.value.position.0
    }
    if tile.value.position.0 < minX {
      minX = tile.value.position.0
    }
    if tile.value.position.1 > maxY {
      maxY = tile.value.position.0
    }
    if tile.value.position.1 < minY {
      minY = tile.value.position.0
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
      let tilePosX = x + minX
      let tilePosY = y + minY
      if floor["\(tilePosX),\(tilePosY)"] == nil {
        newFloor["\(tilePosX),\(tilePosY)"] = Tile(x: tilePosX, y: tilePosY, isBlack: false)
        // print("adding at \(tilePosX),\(tilePosY)")
      }
    }
  }

  newFloor.merge(floor) { (current, _) in current }
  // print("done filling")
  // printFloor(newFloor)
  // print("\n\n\n\n")
  return newFloor
}

func addNewOutsideRow(_ floor: [String: Tile]) -> [String: Tile] {
  var newFloor = floor
  var maxX = 0, minX = 0, maxY = 0, minY = 0
  for tile in floor {
    if tile.value.position.0 > maxX {
      maxX = tile.value.position.0
    }
    if tile.value.position.0 < minX {
      minX = tile.value.position.0
    }
    if tile.value.position.1 > maxY {
      maxY = tile.value.position.1
    }
    if tile.value.position.1 < minY {
      minY = tile.value.position.1
    }
  }
  let floorX = maxX + abs(minX)

  // print("minX: \(minX), maxX: \(maxX), minY: \(minY), maxY: \(maxY), floorX: \(floorX), floorY: \(floorY)")

  // Top
  // printFloor(newFloor + floor)
  let topRowBlacks = floor.filter { $0.value.position.1 == minY && $0.value.isBlack }
  if topRowBlacks.count > 0 {
    // print("we need to add a top row")
    let configTop = floor.contains(where: { $0.value.position == (maxX, minY) })
    // print("configTop is \(configTop)")
    for x in 0...floorX {
      // print("y is \(y), minY is \(minY), floorY is \(floorY)")
      if configTop {
        if x % 2 == 0 {
          let tilePosX = x + minX
          let tilePosY = minY - 1
          newFloor["\(tilePosX),\(tilePosY)"] = Tile(x: tilePosX, y: tilePosY, isBlack: false)
        } else {
          continue
        }
      } else {
        if x % 2 == 0 {
          continue
        } else {
          let tilePosX = x + minX
          let tilePosY = minY - 1
          newFloor["\(tilePosX),\(tilePosY)"] = Tile(x: tilePosX, y: tilePosY, isBlack: false)
        }
      }
    }
  }


  // Bottom
  // printFloor(newFloor + floor)
  let botRow = floor.filter { $0.value.position.1 == maxY }
  let leftBottomX = botRow.reduce(0, { acc, tile in
    return tile.value.position.0 < acc ? tile.value.position.0 : acc
  } )
  let botRowBlacks = floor.filter { $0.value.position.1 == maxY && $0.value.isBlack }
  if botRowBlacks.count > 0 {
    // print("we need to add a bottom row")
    for x in 0...floorX {
      if leftBottomX == minX {
        if x % 2 == 0 {
          continue
        }
      } else {
        if x % 2 != 0 {
          continue
        }
      }
      let tilePosX = x + minX
      let tilePosY = maxY + 1
      newFloor["\(tilePosX),\(tilePosY)"] = Tile(x: tilePosX, y: tilePosY, isBlack: false)
    }
  }


  // Left
  // printFloor(newFloor + floor)
  for tile in newFloor {
    if tile.value.position.0 > maxX {
      maxX = tile.value.position.0
    }
    if tile.value.position.0 < minX {
      minX = tile.value.position.0
    }
    if tile.value.position.1 > maxY {
      maxY = tile.value.position.1
    }
    if tile.value.position.1 < minY {
      minY = tile.value.position.1
    }
  }
  var newFloorY = maxY + abs(minY)


  let leftColBlacks = newFloor.filter { ($0.value.position.0 == minX || $0.value.position.0 == minX + 1) && $0.value.isBlack }
  if leftColBlacks.count > 0 {
    let checkTilePosition = (minX , minY)
    // print("we need to add a left column, checking \(checkTilePosition)")
    let configLeft = newFloor.contains(where: { $0.value.position == checkTilePosition })
    for y in 0...(newFloorY) {
      // print("y is \(y), minY is \(minY), floorY is \(floorY)")
      if configLeft {
        // print("tile found!")
        if y % 2 == 0 {
          let tilePosX = minX - 2
          let tilePosY = y + minY
          newFloor["\(tilePosX),\(tilePosY)"] = Tile(x: tilePosX, y: tilePosY, isBlack: false)
        } else {
          let tilePosX = minX - 1
          let tilePosY = y + minY
          newFloor["\(tilePosX),\(tilePosY)"] = Tile(x: tilePosX, y: tilePosY, isBlack: false)
        }
      } else {
        // print("tile not found")
        if y % 2 == 0 {
          let tilePosX = minX - 1
          let tilePosY = y + minY
          newFloor["\(tilePosX),\(tilePosY)"] = Tile(x: tilePosX, y: tilePosY, isBlack: false)
        } else {
          let tilePosX = minX - 2
          let tilePosY = y + minY
          newFloor["\(tilePosX),\(tilePosY)"] = Tile(x: tilePosX, y: tilePosY, isBlack: false)
        }
      }
    }
  }

  for tile in newFloor {
    if tile.value.position.0 > maxX {
      maxX = tile.value.position.0
    }
    if tile.value.position.0 < minX {
      minX = tile.value.position.0
    }
    if tile.value.position.1 > maxY {
      maxY = tile.value.position.1
    }
    if tile.value.position.1 < minY {
      minY = tile.value.position.1
    }
  }
  newFloorY = maxY + abs(minY)

  let rightColBlacks = newFloor.filter { ($0.value.position.0 == maxX || $0.value.position.0 == maxX - 1) && $0.value.isBlack }
  if rightColBlacks.count > 0 {
    // print("we need to add a right column")
    let configRight = newFloor.contains(where: { $0.value.position == (maxX, minY) })
    // print("configRight is \(configRight)")
    for y in 0...(newFloorY) {
      // print("y is \(y), minY is \(minY), floorY is \(floorY)")
      if configRight {
        if y % 2 == 0 {
          let tilePosX = maxX + 2
          let tilePosY = y + minY
          newFloor["\(tilePosX),\(tilePosY)"] = Tile(x: tilePosX, y: tilePosY, isBlack: false)
        } else {
          let tilePosX = maxX + 1
          let tilePosY = y + minY
          newFloor["\(tilePosX),\(tilePosY)"] = Tile(x: tilePosX, y: tilePosY, isBlack: false)
        }
      } else {
        if y % 2 == 0 {
          let tilePosX = maxX + 1
          let tilePosY = y + minY
          newFloor["\(tilePosX),\(tilePosY)"] = Tile(x: tilePosX, y: tilePosY, isBlack: false)
        } else {
          let tilePosX = maxX + 2
          let tilePosY = y + minY
          newFloor["\(tilePosX),\(tilePosY)"] = Tile(x: tilePosX, y: tilePosY, isBlack: false)
        }
      }
    }
  }

  return newFloor
}


func getAdjacentPositions(_ position: (Int, Int)) -> [(Int, Int)] {
  let adjPositions = [
    (position.0 + 1, position.1 - 1),
    (position.0 + 2, position.1),
    (position.0 + 1, position.1 + 1),
    (position.0 - 1, position.1 + 1),
    (position.0 - 2, position.1),
    (position.0 - 1, position.1 - 1)
  ]
  return adjPositions
}

func countBlackTiles(_ floorGrid: [String: Tile]) -> Int {
  let blackCount = floorGrid.reduce(0, { (acc, tile) in
      return tile.value.isBlack ? acc + 1 : acc
    })
  return blackCount
}

func printFloor(_ floor: [String: Tile]) -> Void {
  var maxX = 0, minX = 0, maxY = 0, minY = 0
  for tile in floor {
    if tile.value.position.0 > maxX {
      maxX = tile.value.position.0
    }
    if tile.value.position.0 < minX {
      minX = tile.value.position.0
    }
    if tile.value.position.1 > maxY {
      maxY = tile.value.position.1
    }
    if tile.value.position.1 < minY {
      minY = tile.value.position.1
    }
  }

  for y in minY...maxY {
    for x in minX...maxX {
      var printChar = " "
      guard let tileToPrint = floor["\(x),\(y)"] else {
        print(printChar, terminator: "")
        continue
      }
      if tileToPrint.position == (0, 0) {
        printChar = tileToPrint.isBlack ? "☆" : "★"
      } else {
        printChar = tileToPrint.isBlack ? "⬡" : "⬢"
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