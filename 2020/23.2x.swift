import Foundation

// https://adventofcode.com/2020/day/23
let input = Array("186524973")
let testInput = Array("389125467")

let test = true
var cups = (test) ? testInput.map( { Int(String($0))! }) : input.map( { Int(String($0))! })
// cups.append(contentsOf: Array(10...1000000))
cups.append(contentsOf: Array(10...1000))

var cupCircle = CupCircle(cups: cups)
var currentCupIndex = 0
var currentCupLabel = cups.first
var cheatCupsFront = [Int]()
var cheatCupsRear = [Int]()
// for i in 10...1_000_000 {
for i in 10...1_000 {
  if (i - 10) % 4 == 0 {
    cheatCupsFront.append(i)
  } else {
    cheatCupsRear.append(i)
  }
}
cheatCupsFront.append(contentsOf: [3, 4, 6, 7, 2, 5])
cheatCupsRear.append(1)

  // print("-- move \(i) -- ")
  // print(cupCircle)
  // let pickedUp = cupCircle.pick()
  // print("pick up:", pickedUp)
  // let destination = cupCircle.destination()
  // print("destination", cupCircle.cups[destination])
  // cupCircle.put(after: destination)
  // cupCircle.next()
  // print(cupCircle.currentIndex)
// }

print(cheatCupsFront + cheatCupsRear)
// let indexOfOne = cupCircle.cups.firstIndex(where: { $0 == 1 })
// print(cupCircle.cups[Int(indexOfOne!) + 1], cupCircle.cups[Int(indexOfOne!) + 2], cupCircle.cups[Int(indexOfOne!) + 1] * cupCircle.cups[Int(indexOfOne!) + 2])

struct CupCircle: CustomStringConvertible {
  var description: String {
    var str = ""
    for cup in self.cups {
      if cup == self.currentLabel {
        str += "(" + String(cup) + ") "
      } else {
        str += " " + String(cup) + "  "
      }
    }
    return str
  }

  var cups: [Int]
  var currentIndex = 0
  var currentLabel: Int
  var picked = [Int]()

  init(cups: [Int]) {
    self.cups = cups
    self.currentLabel = cups[self.currentIndex]
  }

  mutating func pick() -> [Int] {
    let circleLastIndex = self.cups.count - 1
    var pickIndex = self.currentIndex + 1
    var picked = [Int]()
    if pickIndex > circleLastIndex {
      pickIndex = 0
    }
    for _ in 1...3 {
      if self.cups.indices.contains(pickIndex) == false {
        pickIndex = 0
      }
      // print("picking from \(pickIndex)", self.cups, picked)
      picked.append(self.cups.remove(at: pickIndex))
    }
    self.picked = picked
    return picked
  }

  func destination() -> Int{
    var destinationLabel = self.currentLabel - 1
    var destinationCupIndex = self.cups.firstIndex(where: { $0 == destinationLabel } )
    // print("destination", destinationLabel)
    // print(destinationCupIndex)
    while destinationCupIndex == nil {
      destinationLabel -= 1
      if destinationLabel < self.cups.min()! {
        destinationLabel = self.cups.max()!
      }
      destinationCupIndex = self.cups.firstIndex(where: { $0 == destinationLabel} )
    }
    return destinationCupIndex!
  }

  mutating func put(after: Int) -> Void{
    self.cups.insert(contentsOf: self.picked, at: after + 1)
  }

  mutating func next() {
    var nextCurrent = Int(self.cups.firstIndex(where: { $0 == self.currentLabel})!) + 1
    if nextCurrent >= self.cups.count {
      nextCurrent = 0
    }
    self.currentIndex = nextCurrent
    self.currentLabel = self.cups[nextCurrent]
  }

  func order() -> String {
    var order = ""
    var index = Int(self.cups.firstIndex(where: { $0 == 1 })!) + 1
    for _ in 1..<self.cups.count {
      if self.cups.indices.contains(index) == false {
        index = 0
      }
      order += String(self.cups[index])
      index += 1
    }
    return order
  }

}