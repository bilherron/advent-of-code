import Foundation

let file = "3.input.txt"
let TREE = "#"
var x = 0
var y = 0
var treeCount = 0
do {
    let terrain = try String(contentsOfFile: file, encoding: .ascii)
    let terrainLines = terrain.components(separatedBy: "\n")
    var terrainArray: [[Any]] = []
    for i in 0...(terrainLines.count - 1) {
        let t = Array(terrainLines[i])
        terrainArray.append(t)
    }
    // Part 1
    print(countTrees(terrainMap: terrainArray, right: 3, down: 1))

    // Part 2
    let run1 = countTrees(terrainMap: terrainArray, right: 1, down: 1)
    let run2 = countTrees(terrainMap: terrainArray, right: 3, down: 1)
    let run3 = countTrees(terrainMap: terrainArray, right: 5, down: 1)
    let run4 = countTrees(terrainMap: terrainArray, right: 7, down: 1)
    let run5 = countTrees(terrainMap: terrainArray, right: 1, down: 2)
    print(run1 * run2 * run3 * run4 * run5)
}
catch let error {
    print("Ooops! Something went wrong: \(error)")
}

func countTrees(terrainMap: Array<Array<Any>>, right: Int, down: Int) -> Int {
    let width = terrainMap[0].count
    let height = terrainMap.count
    var treeCount = 0
    var x = 0
    var y = 0
    while y < height {
        let mapTile = String(describing: terrainMap[y][x])
        if mapTile == TREE {
            treeCount += 1
        }
        y = y + down
        x = x + right
        if x > (width - 1) {
            x = x - width
        }
    }
    return treeCount
}