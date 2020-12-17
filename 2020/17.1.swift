import Foundation

// https://adventofcode.com/2020/day/17
let input = importPuzzleInput("./17.input.txt")
var pocketDimension = [[[Int]]]()
let startSlice = input.components(separatedBy: "\n").map { $0.map { (element) -> Int in if element == "#" { return 1 } else { return 0 }} }
pocketDimension.insert(startSlice, at: 0)
var shadowDimension = pocketDimension

func changeState(_ x: Int, _ y: Int, _ z: Int) -> Void {
  let thisCube = pocketDimension[z][y][x]
  var activeNeighborCount = 0
  for zOffset in -1...1 {
    let checkZ = z + zOffset
    if pocketDimension.indices.contains(checkZ) != true {
      continue
    }
    for yOffset in -1...1 {
      let checkY = y + yOffset
      if pocketDimension[checkZ].indices.contains(checkY) != true {
        continue
      }
      for xOffset in -1...1 {
        let checkX = x + xOffset
        if pocketDimension[checkZ][checkY].indices.contains(checkX) != true {
          continue
        }
        if xOffset == 0 && yOffset == 0 && zOffset == 0 {
          continue
        }
        if pocketDimension[checkZ][checkY][checkX] == 1 {
          activeNeighborCount += 1
        }
      }
    }
  }
  if thisCube == 1 {
    if activeNeighborCount == 2 || activeNeighborCount == 3 {
      shadowDimension[z][y][x] = 1
    } else {
      shadowDimension[z][y][x] = 0
    }
  } else {
    if activeNeighborCount == 3 {
      shadowDimension[z][y][x] = 1
    } else {
      shadowDimension[z][y][x] = 0
    }
  }
}

for _ in 1...6 {
  let emptyOneDSlice = Array(repeating: 0, count: pocketDimension[0][0].count + 2)
  let emptyTwoDSlice = Array(repeating: emptyOneDSlice, count: pocketDimension[0].count + 2)
  for (yIndex, twoDSlice) in pocketDimension.enumerated() {
    for (xIndex, _) in twoDSlice.enumerated() {
      pocketDimension[yIndex][xIndex].insert(0, at: 0)
      pocketDimension[yIndex][xIndex].append(0)
    }
    pocketDimension[yIndex].insert(emptyOneDSlice, at: 0)
    pocketDimension[yIndex].append(emptyOneDSlice)
  }
  pocketDimension.insert(emptyTwoDSlice, at: 0)
  pocketDimension.append(emptyTwoDSlice)
  shadowDimension = pocketDimension
  for (z, twoDSlice) in pocketDimension.enumerated() {
    for (y, oneDSlice) in twoDSlice.enumerated() {
      for (x, _) in oneDSlice.enumerated() {
        changeState(x, y, z)
      }
    }
  }
  pocketDimension = shadowDimension
}
print(countActiveCubes())

func countActiveCubes() -> Int {
  var activeCubes = 0
  for twoDSlice in pocketDimension {
    for oneDSlice in twoDSlice {
      for cubeState in oneDSlice {
        if cubeState == 1 {
          activeCubes += 1
        }
      }
    }
  }
  return activeCubes
}

func printDimension() -> Void {
  for twoDSlice in pocketDimension {
    for oneDSlice in twoDSlice {
      for cubeState in oneDSlice {
        let cubeStateGlyph = (cubeState == 1) ? "#" : "."
        print(cubeStateGlyph, terminator: "")
      }
      print("")
    }
    print("")
  }
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