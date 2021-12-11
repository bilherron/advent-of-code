import Foundation

// https://adventofcode.com/2020/day/20
let input = importPuzzleInput("./20.input.txt")
let testInput = importPuzzleInput("./20.input.test.txt")

let test = true
let rawTiles = (test) ? testInput.components(separatedBy: "\n\n") : input.components(separatedBy: "\n\n")
var tiles = [Tile]()
for tile in rawTiles {
  let tileParts = tile.components(separatedBy: ":\n")
  let tileIdStr = tileParts[0].replacingOccurrences(of: "Tile ", with: "")
  tiles.append(Tile(id: Int(tileIdStr)!, pixels: tileParts[1].components(separatedBy: "\n").map { $0.map { String($0) } }))
}

let rows = Int(Double(tiles.count).squareRoot())
let seams = (rows - 1) * rows * 2

var corners = [Int: Set<String>]()
var sides = [Int: Set<String>]()
var middles = [Int: Set<String>]()

var otherTileEdges = [String]()
for otherTiles in tiles {
  otherTileEdges.append(contentsOf: otherTiles.allEdges)
}
var edgeCounts: [String: Int] = [:]
var candidateEdges = [String]()
var edgeCountCounts: [Int: Int] = [:]

otherTileEdges.forEach { edgeCounts[$0, default: 0] += 1 }
// print(edgeCounts as AnyObject)
edgeCounts.forEach {
  if $0.value == 2 {
    candidateEdges.append($0.key)
  }
}

for tile in tiles {
  print("--------------", tile.id, "--------------")

  let intersect = Set(candidateEdges).intersection(Set(tile.edges))

  if intersect.count == 2 {
    tile.render()
    print(tile.edges)
    print(intersect)
    corners[tile.id] = intersect
  }
  if intersect.count == 3 {
    sides[tile.id] = intersect
  }
  if intersect.count == 4 {
    middles[tile.id] = intersect
  }
}
print("middles", middles.count, "sides", sides.count, "corners", corners.count)

let pictureGrid = Array(repeating: Array(repeating: 0, count: rows), count: rows)

// get matched edges
// find a side that matches



func printEdgeMapping(_ edges: [String], _ edgeCounts: [String: Int]) -> Void {
  print("++++++++")
  for edge in edges {
    if edgeCounts[edge] != nil {
      print("edge", edge, edgeCounts[edge]!)
    } else {
      print("edge", edge, 0)
    }
  }
}

func countMatchedEdges(_ tiles: [Tile]) -> Int {
  // print(edgeCounts)
  // print(edgeCountCounts)
  return 1 //edgeCountCounts[2]!
}

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

  func printAllEdges() -> Void {
    for edge in self.allEdges {
      print(edge)
    }
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

  func flipV() -> Void {
    var newPixels = [[String]]()
    let dimension = self.pixels.count
    for i in 1...dimension {
      newPixels.append(self.pixels[dimension - i])
    }
    self.pixels = newPixels
    self.setEdges()
  }
  func flipH() -> Void {
    var newPixels = [[String]]()
    let dimension = self.pixels.count
    for i in 0..<dimension {
      var row = self.pixels[i]
      row.reverse()
      newPixels.append(row)
    }
    self.pixels = newPixels
    self.setEdges()
  }

  func rotate90() -> Void {
    let dimension = self.pixels.count
    var newPixels = Array(repeating: Array(repeating: ".", count: dimension), count: dimension)
    for y in 0..<dimension {
      for x in 0..<dimension {
        let newY = x
        let newX = (dimension - 1) - y
        newPixels[newY][newX] = self.pixels[y][x]
      }
    }
    self.pixels = newPixels
    self.setEdges()
  }
  func rotate270() -> Void {
    let dimension = self.pixels.count
    var newPixels = Array(repeating: Array(repeating: ".", count: dimension), count: dimension)
    for y in 0..<dimension {
      for x in 0..<dimension {
        let newY = (dimension - 1) - x
        let newX = y
        newPixels[newY][newX] = self.pixels[y][x]
      }
    }
    self.pixels = newPixels
    self.setEdges()
  }

  func render() -> Void {
    for row in self.pixels {
      print(row.joined())
    }
  }

  func countMatchedEdges() -> Int {
    print(self.edges)
    return 1
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
