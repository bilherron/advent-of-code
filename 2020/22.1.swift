import Foundation

// https://adventofcode.com/2020/day/22
let input = importPuzzleInput("./22.input.txt")
let testInput = importPuzzleInput("./22.input.test.txt")

let test = false
let decks = (test) ? testInput.components(separatedBy: "\n\n") : input.components(separatedBy: "\n\n")

var deck1 = Deck(decks[0].components(separatedBy: "\n").map { Int($0)! })
var deck2 = Deck(decks[1].components(separatedBy: "\n").map { Int($0)! })

var turnCount = 1

while deck1.stillInTheGame() && deck2.stillInTheGame() {

//   print("""
// -- Round \(turnCount) --
// Player 1's deck: \(deck1.printDeck())
// Player 2's deck: \(deck2.printDeck())
// """)
  let play1 = deck1.play()
  let play2 = deck2.play()
//   print("""
// Player 1 plays: \(play1)
// Player 2 plays: \(play2)
// Player \(play1 > play2 ? 1 : 2) wins the round!
// """)
  if play1 > play2 {
    deck1.wins(play1, play2)
  } else {
    deck2.wins(play1, play2)
  }
  turnCount += 1
}
print("player 1 score", deck1.score())
print("player 2 score", deck2.score())

class Deck {
  var cards: [Int]

  init(_ cardArr: [Int]) {
    self.cards = cardArr
  }

  func play() -> Int {
    return self.cards.removeFirst()
  }

  func wins(_ card1: Int, _ card2: Int) -> Void {
    let newCards = Array([card1, card2].sorted().reversed())
    self.cards.append(contentsOf: newCards)
  }

  func stillInTheGame() -> Bool {
    return self.cards.count > 0
  }

  func printDeck() -> String {
    return self.cards.map({ String($0) }).joined(separator: ", ")
  }

  func score() -> Int {
    let cardCount = self.cards.count
    if cardCount == 0 {
      return 0
    }
    var score = 0
    for i in 0..<cardCount {
      score += ((i + 1) * self.cards[(cardCount - 1) - i])
    }
    return score
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
