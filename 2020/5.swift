import Foundation

let input = "5.input.txt"
do {
    let boardingPasses = try String(contentsOfFile: input, encoding: .ascii).components(separatedBy: "\n")
    var seatIds = [Int]()
    for boardingPass in boardingPasses {
        seatIds.append(getSeatId(boardingPass: boardingPass))
    }

    // part 1
    print("The highest seat ID is \(seatIds.max()!)")

    // part 2
    seatIds.sort()
    for i in 0...seatIds.count - 2 {
        if (seatIds[i] + 1) != seatIds[i+1] {
            print("Your seat ID is \(seatIds[i] + 1)")
        }
    }
}
catch let error {
    print(error)
}

func getSeatId(boardingPass: String) -> Int {
    let rowComponent = String(boardingPass[boardingPass.startIndex..<boardingPass.index(boardingPass.startIndex, offsetBy: 7)])
    let colComponent = String(boardingPass[boardingPass.index(boardingPass.endIndex, offsetBy: -3)..<boardingPass.endIndex])
    let row = getRow(rowComponent: rowComponent)
    let col = getCol(colComponent: colComponent)
    return (row * 8) + col
}

func getRow(rowComponent: String) -> Int {
    var low = 0, high = 127
    for fb in rowComponent {
        (low, high) = narrowRange(low: low, high: high, narrower: String(fb))
    }
    return low
}
func getCol(colComponent: String) -> Int {
    var low = 0, high = 7
    for lr in colComponent {
        (low, high) = narrowRange(low: low, high: high, narrower: String(lr))
    }
    return low
}

func narrowRange(low: Int, high: Int, narrower: String) -> (Int, Int) {
    let lowMidpoint = low + ((high - low - 1) / 2)
    let lowRange = (low, lowMidpoint)
    let highRange = (lowMidpoint + 1, high)
    if narrower == "F" || narrower == "L" {
        return lowRange
    }
    return highRange
}