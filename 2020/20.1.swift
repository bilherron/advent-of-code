import Foundation

// https://adventofcode.com/2020/day/20
let input = importPuzzleInput("./20.input.txt")
let testInput = importPuzzleInput("./20.input.test.txt")

let rawTiles = input.components(separatedBy: "\n\n")
var tiles = [Tile]()
for tile in rawTiles {
  let tileParts = tile.components(separatedBy: ":\n")
  let tileIdStr = tileParts[0].replacingOccurrences(of: "Tile ", with: "")
  tiles.append(Tile(id: Int(tileIdStr)!, pixels: tileParts[1].components(separatedBy: "\n").map { $0.map { String($0) } }))
}

var answer = 1
for tile in tiles {
  var otherTileEdges = [String]()
  for otherTiles in tiles {
    otherTileEdges.append(contentsOf: otherTiles.allEdges)
  }
  var edgeCounts: [String: Int] = [:]
  var candidateEdges = [String]()

  otherTileEdges.forEach { edgeCounts[$0, default: 0] += 1 }
  edgeCounts.forEach {
    if $0.value == 2 {
      candidateEdges.append($0.key)
    }
   }
  let intersect = Set(candidateEdges).intersection(Set(tile.edges))
  if intersect.count == 2 {
    answer *= tile.id
  }
}
print("answer", answer)

class Tile {
  var edges = [String]()
  var allEdges = [String]()
  var id: Int
  var pixels: [[String]]

  init(id: Int, pixels: [[String]]) {
    self.id = id
    self.pixels = pixels
    self.setEdges()
  }

  func setEdges() -> Void {
    var newEdges = [String]()
    var allEdges = [String]()
    let top = pixels.first!.joined()
    let bottom = pixels.last!.joined()
    newEdges.append(top)
    newEdges.append(bottom)
    var left = "", right = ""
    for pixel in pixels {
      left += pixel.first!
      right += pixel.last!
    }
    newEdges.append(left)
    newEdges.append(right)
    self.edges = newEdges
    allEdges = newEdges
    allEdges.append(String(top.reversed()))
    allEdges.append(String(bottom.reversed()))
    allEdges.append(String(left.reversed()))
    allEdges.append(String(right.reversed()))
    self.allEdges = allEdges
  }

  func render() -> Void {
    for row in self.pixels {
      print(row.joined())
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
