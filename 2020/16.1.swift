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
let myTicket = "157,89,103,59,101,181,109,127,67,173,151,97,107,167,61,131,53,163,179,113"
let nearbyTickets = importPuzzleInput("./16.input.txt").components(separatedBy: "\n")

let testRules = """
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50
""".components(separatedBy: "\n")
let myTestTicket = "7,1,14"
let testNearbyTickets = [
  "7,3,47",
  "40,4,50",
  "55,2,20",
  "38,6,12"
]

let ticketScanner = TicketScanner(rules)
var errorRate = 0
for nearTicket in nearbyTickets {
  let nearTicketValues = nearTicket.components(separatedBy: ",").map { Int($0) }
  for checkValue in nearTicketValues {
    if ticketScanner.validateValue(checkValue!) != true {
      errorRate += checkValue!
    }
  }
}
print(errorRate)

class TicketScanner {
  var rules = [String: [Int]]()
  var validValues = [Int]()

  init(_ rulesRaw: [String]) {
    for rule in rulesRaw {
      let ruleParts = rule.components(separatedBy: ": ")
      let ranges = ruleParts[1].components(separatedBy: " or ")
      for range in ranges {
        let rangeParts = range.components(separatedBy: "-").map { Int($0) }
        self.validValues += Array(rangeParts[0]!...rangeParts[1]!)
      }
    }
  }

  func validateValue(_ value: Int) -> Bool {
    return self.validValues.contains(value)
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