import Foundation

// https://adventofcode.com/2020/day/16

let rules = """
departure location: 32-69 or 86-968
departure station: 27-290 or 301-952
departure platform: 47-330 or 347-956
departure track: 46-804 or 826-956
departure date: 25-302 or 320-959
departure time: 29-885 or 893-961
arrival location: 33-643 or 649-963
arrival station: 29-135 or 151-973
arrival platform: 50-648 or 674-961
arrival track: 45-761 or 767-971
class: 46-703 or 725-951
duration: 47-244 or 257-957
price: 49-195 or 209-956
route: 44-368 or 393-968
row: 48-778 or 797-954
seat: 31-421 or 427-964
train: 42-229 or 245-961
type: 31-261 or 281-964
wagon: 36-428 or 445-967
zone: 30-906 or 923-960
""".components(separatedBy: "\n")
let myTicket = "157,89,103,59,101,181,109,127,67,173,151,97,107,167,61,131,53,163,179,113".components(separatedBy: ",").map { Int($0)! }
var nearbyTickets = importPuzzleInput("./16.input.txt").components(separatedBy: "\n").map { String($0).components(separatedBy: ",").map { Int($0)! } }

// let rules = """
// class: 0-1 or 4-19
// row: 0-5 or 8-19
// seat: 0-13 or 16-19
// """.components(separatedBy: "\n")
// let myTicket = "11,12,13".components(separatedBy: ",").map { Int($0)! }
// var nearbyTickets = ["3,9,18", "15,1,5", "5,14,9"].map { String($0).components(separatedBy: ",").map { Int($0)! } }

let ticketScanner = TicketScanner(rules)

// remove invalid tickets
for nearTicket in nearbyTickets {
  for checkValue in nearTicket {
    if ticketScanner.validateValue(checkValue) != true {
      nearbyTickets.remove(at: nearbyTickets.firstIndex(of: nearTicket)!)
    }
  }
}

let allTickets = [myTicket] + nearbyTickets
var possibilities = [Set<String>]()
for ticket in allTickets {
  for (index, ticketValue) in ticket.enumerated() {
    let p = ticketScanner.findRules(forValue: ticketValue)
    if possibilities.indices.contains(index) {
      possibilities[index] = possibilities[index].intersection(p)
    } else {
      possibilities.insert(p, at: index)
    }
  }
}

var definites = [String: Int]()
var removables = Set<String>()
while definites.count < rules.count {
  for (index, possibles) in possibilities.enumerated() {
    if possibles.count == 1 {
      let definiteField = possibles.first!
      definites[definiteField] = index
      removables.insert(definiteField)
    }
    possibilities[index] = possibilities[index].subtracting(removables)
  }
}
var answer = 1
for definite in definites {
  if definite.key.hasPrefix("departure") {
    answer *= myTicket[definite.value]
  }
}
print(answer)

class TicketScanner {
  var rules: [String: [Int]] = [:]
  var validValues = [Int]()

  init(_ rulesRaw: [String]) {
    for rule in rulesRaw {
      let ruleParts = rule.components(separatedBy: ": ")
      let ranges = ruleParts[1].components(separatedBy: " or ")
      self.rules[ruleParts[0]] = [Int]()
      for range in ranges {
        let rangeParts = range.components(separatedBy: "-").map { Int($0) }
        self.validValues += Array(rangeParts[0]!...rangeParts[1]!)
        self.rules[ruleParts[0]]! += Array(rangeParts[0]!...rangeParts[1]!)
      }
    }
  }

  func validateValue(_ value: Int) -> Bool {
    return self.validValues.contains(value)
  }

  func findRules(forValue: Int) -> Set<String> {
    var validRules = Set<String>()
    for rule in self.rules {
      if rule.value.contains(forValue) {
        validRules.insert(rule.key)
      }
    }
    return validRules
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