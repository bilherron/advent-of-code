import Foundation

// https://adventofcode.com/2020/day/22
let input = importPuzzleInput("./22.input.txt")
let testInput = importPuzzleInput("./22.input.test.txt")

let test = false
let decks = (test) ? testInput.components(separatedBy: "\n\n") : input.components(separatedBy: "\n\n")

let deck1 = decks[0].components(separatedBy: "\n").map { Int($0)! }
let deck2 = decks[1].components(separatedBy: "\n").map { Int($0)! }

var turnCount = 1
var gameCount = 1

var game = Game(playerOneDeck: Deck(deck1), playerTwoDeck: Deck(deck2), gameNumber: gameCount)
let winner = game.play()
print("and the winner is...", winner)
print("player 1 score", game.playerOneDeck.score())
print("player 2 score", game.playerTwoDeck.score())


struct Game {
  var playerOneDeck: Deck
  var playerTwoDeck: Deck
  var state: GameState
  var winner = 0
  var number: Int
  var turnCount = 1

  init(playerOneDeck: Deck, playerTwoDeck: Deck, gameNumber: Int) {
    self.playerOneDeck = playerOneDeck
    self.playerTwoDeck = playerTwoDeck
    self.number = gameNumber
    self.state = GameState()
  }

  mutating func play() -> Int {
    // print("=== Game \(self.number) ===")

    // start round
    while self.playerOneDeck.stillInTheGame() && self.playerTwoDeck.stillInTheGame() {
      if self.summaryJudgementInPlayerOnesFavor() {
        // print("History repeats!!")
        // print("The winner of game \(self.number) is player \(self.winner)!")
        return 1
      }
      self.state.add(self.playerOneDeck, self.playerTwoDeck)

      // print("-- Round \(self.turnCount) (Game \(self.number)) --")
      // print("Player 1's deck: \(self.playerOneDeck.printDeck())")
      // print("Player 2's deck: \(self.playerTwoDeck.printDeck())")
      let play1 = self.playerOneDeck.draw()
      let play2 = self.playerTwoDeck.draw()
      // print("Player 1 plays: \(play1)")
      // print("Player 2 plays: \(play2)")

      let shallWeRecurse = (play1 <= self.playerOneDeck.count()) && (play2 <= self.playerTwoDeck.count())
      if shallWeRecurse {
        // print("Playing a sub-game to determine the winner...")
        let recursedDeck1 = Array(self.playerOneDeck.cardArray()[..<play1])
        let recursedDeck2 = Array(self.playerTwoDeck.cardArray()[..<play2])
        gameCount += 1
        var game = Game(playerOneDeck: Deck(recursedDeck1), playerTwoDeck: Deck(recursedDeck2), gameNumber: gameCount)
        let recursedWinner = game.play()
        if recursedWinner == 1 {
          self.playerOneDeck.wins(play1, play2)
        } else {
          self.playerTwoDeck.wins(play2, play1)
        }
        // print("Player \(recursedWinner) wins round \(self.turnCount) of game \(gameCount)!")
      } else {
        if play1 > play2 {
          self.playerOneDeck.wins(play1, play2)
        } else {
          self.playerTwoDeck.wins(play2, play1)
        }
      }
      self.turnCount += 1
    } // end round

    if self.playerOneDeck.stillInTheGame() {
      self.winner = 1
    } else {
      self.winner = 2
    }
    // print("The winner of game \(self.number) is player \(self.winner)!")
    return self.winner
  }

  func currentState() -> (Deck, Deck) {
    return (self.playerOneDeck, self.playerTwoDeck)
  }

  mutating func summaryJudgementInPlayerOnesFavor() -> Bool {
    if self.state.contains(nextState: self.currentState()) {
      self.winner = 1
      return true
    }
    return false
  }

}

struct GameState {
  var history = [String]()

  mutating func add(_ deck1: Deck, _ deck2: Deck) {
    let historyString = deck1.cardArray().map({ String($0) }).joined() + ":" + deck2.cardArray().map({ String($0) }).joined()
    self.history.append(historyString)
  }

  func contains(nextState: (Deck, Deck)) -> Bool {
    let checkString = nextState.0.cardArray().map({ String($0) }).joined() + ":" + nextState.1.cardArray().map({ String($0) }).joined()
    for turn in self.history {
      if turn == checkString {
        return true
      }
    }
    return false
  }
}

class Deck {
  var cards: [Int]

  init(_ cardArr: [Int]) {
    self.cards = cardArr
  }

  func draw() -> Int {
    return self.cards.removeFirst()
  }

  func wins(_ winningPlayerCard: Int, _ losingPlayerCard: Int) -> Void {
    self.cards.append(contentsOf: [winningPlayerCard, losingPlayerCard])
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
      // print("score", score, "add (i \(i) * self.cards[\(self.cards.count - 1)-0)] \(self.cards[i - 1])) = \((i * self.cards[i - 1]))")
      score += ((i + 1) * self.cards[(cardCount - 1) - i])
    }
    return score
  }

  func cardArray() -> [Int] {
    return self.cards
  }

  func count() -> Int {
    return self.cards.count
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
