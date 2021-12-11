import Foundation

// https://adventofcode.com/2020/day/25
let test = true
let cardPubKey = test ? 5764801 : 14082811
let doorPubKey = test ? 17807724 : 5249543

var value = 1
var cardLoop = 1
var doorLoop = 1
var cardSubject = 1
var doorSubject = 1
// var possibleCardLoops = [Int]()

func modPow(number: Decimal, exponent: Decimal, mod: Decimal) -> Decimal {
  guard exponent != 0 else {
    return Decimal(1)
  }

  var res = Decimal(1)
  var base = number % mod
  var exp = exponent

  while true {
    // if exp & 1 == 1 {
      res *= base
      res = res % mod
    // }

    if exp == 1 {
      return res
    }

    exp /= 2
    base *= base
    base = base % mod
  }
}

let a = Decimal(string: "2988348162058574136915891421498819466320163312926952423791023078876139")!
let b = Decimal(string: "2351399303373464486466122544523690094744975233415544072992656881240319")!

//  pow(Decimal(10), 40)
let modParam = pow(10, 40)
print(modPow(number: a, exponent: b, mod: modParam))

func % (lhs: Decimal, rhs: Decimal) -> Decimal {
    print("lhs", lhs)
    print("rhs", rhs)
    precondition(lhs > Decimal(0) && rhs > Decimal(0))

    if lhs < rhs {
        return lhs
    } else if lhs == rhs {
        return Decimal(0)
    }

    var quotient = lhs / rhs
    var rounded = Decimal()
    NSDecimalRound(&rounded, &quotient, 0, .down)

    return lhs - (rounded * rhs)
}

// while value != cardPubKey {
//   for _ in 1...loopSize {
//     value *= subject
//     let remainder = value % 20201227
//     value = remainder
//   }
//   return value
// }

// for sub in 2...10 {
//   for loop in 0...12 {
//     let cardCheck = ((20201227 * loop) + cardPubKey) % sub
//     let doorCheck = ((20201227 * loop) + doorPubKey) % sub
//     // print(cardCheck, doorCheck)
//     if cardCheck == 0 && doorCheck == 0 {
//       print("match on sub \(sub) loop \(loop)")
//     }
//   }
// }
