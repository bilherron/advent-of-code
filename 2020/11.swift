import Foundation

// https://adventofcode.com/2020/day/11
let input = importPuzzleInput("./11.input.txt")
// let input = importPuzzleInput("./11.input.test.txt")
let FLOOR = "."
let EMPTY = "L"
let OCCUPIED = "#"

let startingSeatMap = input.components(separatedBy: "\n").map { $0.map { String($0) } }
var seatMap = startingSeatMap
var nextSeatMap = seatMap

var changes = 1

// part 1
while changes > 0 {
  changes = 0
  for (y, row) in seatMap.enumerated() {
    for (x, mapTile) in row.map({ $0 }).enumerated() {
      let nextMapTile = checkSurroundingSeats(x, y)
      if mapTile != nextMapTile {
        changes += 1
      }
      nextSeatMap[y][x] = nextMapTile
    }
  }
  seatMap = nextSeatMap
}
var seatCounts = seatMap.flatMap( { $0 } ).reduce(into: [:]) { $0[$1, default: 0] += 1 }
print(seatCounts[OCCUPIED]!)

// part 2
seatMap = startingSeatMap
changes = 1
while changes > 0 {
  changes = 0
  for (y, row) in seatMap.enumerated() {
    for (x, mapTile) in row.map({ $0 }).enumerated() {
      let nextMapTile = checkSurroundingSightLines(x, y)
      if mapTile != nextMapTile {
        changes += 1
      }
      nextSeatMap[y][x] = nextMapTile
    }
  }
  seatMap = nextSeatMap
}
seatCounts = seatMap.flatMap( { $0 } ).reduce(into: [:]) { $0[$1, default: 0] += 1 }
print(seatCounts[OCCUPIED]!)

func checkSurroundingSeats(_ x: Int, _ y: Int) -> String {
  if String(seatMap[y][x]) == FLOOR {
    return FLOOR
  }
  var occupiedSurroundings = 0
  for mutX in -1...1 {
    for mutY in -1...1 {
      if mutX == 0 && mutY == 0 {
        continue
      }
      if checkAdjacent(x, y, mutX: mutX, mutY: mutY) == OCCUPIED {
        occupiedSurroundings += 1
      }
    }
  }
  if seatMap[y][x] == EMPTY && occupiedSurroundings == 0 {
    return OCCUPIED
  }
  if seatMap[y][x] == OCCUPIED && occupiedSurroundings >= 4 {
    return EMPTY
  }
  return seatMap[y][x]
}

func checkSurroundingSightLines(_ x: Int, _ y: Int) -> String {
  if String(seatMap[y][x]) == FLOOR {
    return FLOOR
  }
  var occupiedSurroundings = 0
  for mutX in -1...1 {
    for mutY in -1...1 {
      if mutX == 0 && mutY == 0 {
        continue
      }
      if checkDirection(x, y, mutX: mutX, mutY: mutY) == OCCUPIED {
        occupiedSurroundings += 1
      }
    }
  }

  if seatMap[y][x] == EMPTY && occupiedSurroundings == 0 {
    return OCCUPIED
  }
  if seatMap[y][x] == OCCUPIED && occupiedSurroundings >= 5 {
    return EMPTY
  }
  return seatMap[y][x]
}

func checkDirection(_ x: Int, _ y: Int, mutX: Int, mutY: Int) -> String {
  var checkX = x + mutX, checkY = y + mutY
  while seatMap.indices.contains(checkY) && seatMap[checkY].indices.contains(checkX) {
    if seatMap[checkY][checkX] != FLOOR {
      return seatMap[checkY][checkX]
    }
    checkX += mutX
    checkY += mutY
  }
  return FLOOR
}
func checkAdjacent(_ x: Int, _ y: Int, mutX: Int, mutY: Int) -> String {
  let checkX = x + mutX, checkY = y + mutY
  if seatMap.indices.contains(checkY) && seatMap[checkY].indices.contains(checkX) {
    if seatMap[checkY][checkX] != FLOOR {
      return seatMap[checkY][checkX]
    }
  }
  return FLOOR
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