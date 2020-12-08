import Foundation

// https://adventofcode.com/2020/day/7
let input = importPuzzleInput("./7.input.txt")

class Bag {
  var color: String
  var containRules = [String: Int]()
  var canContain = [Bag]()
  
  init(color: String) {
    self.color = color
  }
  
  func contains(bag: Bag) -> Bool {
    if self.canContain.contains(bag) {
      return true
    }
    for containedBag in self.canContain {
      if containedBag.contains(bag: bag) {
        return true
      }
    }
    return false
  }
  
  func countContainedBags() -> Int {
    var containCount = 0
    for containedBag in self.canContain {
      let containedBagCanContainCount = containedBag.countContainedBags()
      containCount += self.containRules[containedBag.color]! + (self.containRules[containedBag.color]! * containedBagCanContainCount)
    }
    return containCount
  }
}

extension Bag: Equatable {
  static func == (lhs: Bag, rhs: Bag) -> Bool {
    return lhs.color == rhs.color
  }
}

let bagRules = input.components(separatedBy: "\n")
var bags = [Bag]()
for rule in bagRules {
  let ruleParse = String(rule).components(separatedBy: " bags contain ")
  let newBagColor = ruleParse[0]
  let newBag = Bag(color: newBagColor)
  if ruleParse[1] != "no other bags." {
    let containedBags = ruleParse[1]
      .replacingOccurrences(of: " bags", with: "")
      .replacingOccurrences(of: " bag", with: "")
      .replacingOccurrences(of: ".", with: "")
      .components(separatedBy: ", ")
    for containedBag in containedBags {
      let separatorIndex = containedBag.index(after: containedBag.firstIndex(of: " ")!)
      let bagCount = containedBag.prefix(while: { "0"..."9" ~= $0 })
      let containedBagColor = String(containedBag[separatorIndex...])
      newBag.containRules[containedBagColor] = Int(bagCount)!         
    }
  }
  bags.append(newBag)
}

for (index, bag) in bags.enumerated() {
  for (bagColor, _) in bag.containRules {
    let appendBag = bags.first(where: { $0.color == bagColor })!
    bags[index].canContain.append(appendBag)
  }
}

let shinyGoldBag = bags.first(where: { $0.color == "shiny gold" })!
let bagsContainingShinyGold = bags.filter {
  return $0.contains(bag: shinyGoldBag)
}

// part 1: How many bag colors can eventually contain at least one shiny gold bag?
print(bagsContainingShinyGold.count)
// part 2: How many individual bags are required inside your single shiny gold bag? 
print(shinyGoldBag.countContainedBags())

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