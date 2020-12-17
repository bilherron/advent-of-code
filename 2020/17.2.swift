import Foundation

// https://adventofcode.com/2020/day/17
let input = importPuzzleInput("./17.input.txt")
var pocketDimension = [[[[Int]]]]()
let startSlice = input.components(separatedBy: "\n").map { $0.map { (element) -> Int in if element == "#" { return 1 } else { return 0 }} }
var start3DSlice = [[[Int]]]()
start3DSlice.insert(startSlice, at: 0)
pocketDimension.insert(start3DSlice, at: 0)
var shadowDimension = pocketDimension

func changeState(_ x: Int, _ y: Int, _ z: Int, _ w: Int) -> Void {
  let thisCube = pocketDimension[w][z][y][x]
  var activeNeighborCount = 0
  for wOffset in -1...1 {
    let checkW = w + wOffset
    if pocketDimension.indices.contains(checkW) != true {
      continue
    }
    for zOffset in -1...1 {
      let checkZ = z + zOffset
      if pocketDimension[checkW].indices.contains(checkZ) != true {
        continue
      }
      for yOffset in -1...1 {
        let checkY = y + yOffset
        if pocketDimension[checkW][checkZ].indices.contains(checkY) != true {
          continue
        }
        for xOffset in -1...1 {
          let checkX = x + xOffset
          if pocketDimension[checkW][checkZ][checkY].indices.contains(checkX) != true {
            continue
          }
          if xOffset == 0 && yOffset == 0 && zOffset == 0 && wOffset == 0 {
            continue
          }
          if pocketDimension[checkW][checkZ][checkY][checkX] == 1 {
            activeNeighborCount += 1
          }
        }
      }
    }
  }
  if thisCube == 1 {
    if activeNeighborCount == 2 || activeNeighborCount == 3 {
      shadowDimension[w][z][y][x] = 1
    } else {
      shadowDimension[w][z][y][x] = 0
    }
  } else {
    if activeNeighborCount == 3 {
      shadowDimension[w][z][y][x] = 1
    } else {
      shadowDimension[w][z][y][x] = 0
    }
  }
}

for cycle in 1...6 {
  print(cycle)
  let emptyOneDSlice = Array(repeating: 0, count: pocketDimension[0][0][0].count + 2)
  let emptyTwoDSlice = Array(repeating: emptyOneDSlice, count: pocketDimension[0][0].count + 2)
  let emptyThreeDSlice = Array(repeating: emptyTwoDSlice, count: pocketDimension[0].count + 2)
  for (zIndex, threeDSlice) in pocketDimension.enumerated() {
    for (yIndex, twoDSlice) in threeDSlice.enumerated() {
      for (xIndex, _) in twoDSlice.enumerated() {
        pocketDimension[zIndex][yIndex][xIndex].insert(0, at: 0)
        pocketDimension[zIndex][yIndex][xIndex].append(0)
      }
      pocketDimension[zIndex][yIndex].insert(emptyOneDSlice, at: 0)
      pocketDimension[zIndex][yIndex].append(emptyOneDSlice)
    }
    pocketDimension[zIndex].insert(emptyTwoDSlice, at: 0)
    pocketDimension[zIndex].append(emptyTwoDSlice)
  }
  pocketDimension.insert(emptyThreeDSlice, at: 0)
  pocketDimension.append(emptyThreeDSlice)

  shadowDimension = pocketDimension
  for (w, threeDSlice) in pocketDimension.enumerated() {
    for (z, twoDSlice) in threeDSlice.enumerated() {
      for (y, oneDSlice) in twoDSlice.enumerated() {
        for (x, _) in oneDSlice.enumerated() {
          changeState(x, y, z, w)
        }
      }
    }
  }
  pocketDimension = shadowDimension
}
print(countActiveCubes())
// printDimension()

func countActiveCubes() -> Int {
  var activeCubes = 0
  for threeDSlice in pocketDimension {
    for twoDSlice in threeDSlice {
      for oneDSlice in twoDSlice {
        for cubeState in oneDSlice {
          if cubeState == 1 {
            activeCubes += 1
          }
        }
      }
    }
  }
  return activeCubes
}

func printDimension() -> Void {
  for threeDSlice in pocketDimension {
    for twoDSlice in threeDSlice {
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