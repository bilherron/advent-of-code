import Foundation

// https://adventofcode.com/2020/day/25
let test = false
let cardPubKey = test ? 5764801 : 14082811
let doorPubKey = test ? 17807724 : 5249543

var value = 1
var cardLoop = 1
var doorLoop = 1
var cardSubject = 1
var doorSubject = 1
// var possibleCardLoops = [Int]()

// for subjectNumber in 1...10000000 {
for subjectNumber in 10000000...20000000 {
  if cardSubject > 1 && doorSubject > 1 && cardSubject == doorSubject {
    print(transform(subject: doorPubKey, loopSize: cardLoop))
    break
  }
  value = 1
  for i in 1...20 {
    // print("\(subjectNumber), \(i): initial value \(value) ", terminator: "")
    value *= subjectNumber
    // print("multiplied \(value) ", terminator: "")
    let remainder = value % 20201227
    // print(" remainder \(remainder)")
    value = remainder
    if value == cardPubKey { //&& cardLoop == 1 {
      // break
      cardSubject = subjectNumber
      cardLoop = i
      // possibleCardLoops.append(cardLoop)
      // print("card: loopSize \(i) subjectNumber: \(subjectNumber)")
      // print(transform(subject: doorPubKey, loopSize: cardLoop))
    }
    if value == doorPubKey {
      doorSubject = subjectNumber
      doorLoop = i
      // print("door: loopSize \(i) subjectNumber: \(subjectNumber)")
    }
    if cardSubject > 1 && cardSubject == subjectNumber && doorSubject == subjectNumber {
      print("door: loopSize \(doorLoop) subjectNumber: \(subjectNumber)")
      print("card: loopSize \(cardLoop) subjectNumber: \(subjectNumber)")
      break
    }
  }
}

// for cardLoop in possibleCardLoops {

// }

// value = 1
// for i in 1...20000 {
//   value *= cardSubject
//   let remainder = value % 20201227
//   value = remainder
//   if value == cardPubKey && cardLoop == 1 {
//     cardSubject = subjectNumber
//     cardLoop = i
//     print("card: loopSize \(i) subjectNumber: \(subjectNumber)")
//   }
//   if value == doorPubKey && doorLoop == 1 {
//     doorSubject = subjectNumber
//     doorLoop = i
//     print("door: loopSize \(i) subjectNumber: \(subjectNumber)")
//   }
// }


// print(transform(subject: card, loopSize: cardLoop))
// 17800063 too high
// 17174675 too high

func transform(subject: Int, loopSize: Int) -> Int {
  // print(loopSize)
  var value = 1
  for _ in 1...loopSize {
    value *= subject
    let remainder = value % 20201227
    value = remainder
  }
  return value
}

// func generateKey(_ pubKey: Int, _ loop: Int) -> Int {

// }
  // for i in 1...`loopSize` {
  //   value *= subjectNumber
  //   let remainder = value % 20201227
  //   value = remainder
  //   if value == cardPubKey {
  //     print("card: loopSize \(i) subjectNumber: \(subjectNumber)")
  //   }
  //   if value == doorPubKey {
  //     print("door: loopSize \(i) subjectNumber: \(subjectNumber)")
  //   }
  // }

// The handshake used by the card and the door involves an operation that transforms a subject number. To transform a subject number, start with the value 1. Then, a number of times called the loop size, perform the following steps:

// Set the value to itself multiplied by the subject number.
// Set the value to the remainder after dividing the value by 20201227.
// The card always uses a specific, secret loop size when it transforms a subject number. The door always uses a different, secret loop size.

// The cryptographic handshake works like this:

// The card transforms the subject number of 7 according to the card's secret loop size. The result is called the card's public key.
// The door transforms the subject number of 7 according to the door's secret loop size. The result is called the door's public key.
// The card and door use the wireless RFID signal to transmit the two public keys (your puzzle input) to the other device. Now, the card has the door's public key, and the door has the card's public key. Because you can eavesdrop on the signal, you have both public keys, but neither device's loop size.
// The card transforms the subject number of the door's public key according to the card's loop size. The result is the encryption key.
// The door transforms the subject number of the card's public key according to the door's loop size. The result is the same encryption key as the card calculated.
// If you can use the two public keys to determine each device's loop size, you will have enough information to calculate the secret encryption key that the card and door use to communicate; this would let you send the unlock command directly to the door!

// For example, suppose you know that the card's public key is 5764801. With a little trial and error, you can work out that the card's loop size must be 8, because transforming the initial subject number of 7 with a loop size of 8 produces 5764801.

// Then, suppose you know that the door's public key is 17807724. By the same process, you can determine that the door's loop size is 11, because transforming the initial subject number of 7 with a loop size of 11 produces 17807724.

// At this point, you can use either device's loop size with the other device's public key to calculate the encryption key. Transforming the subject number of 17807724 (the door's public key) with a loop size of 8 (the card's loop size) produces the encryption key, 14897079. (Transforming the subject number of 5764801 (the card's public key) with a loop size of 11 (the door's loop size) produces the same encryption key: 14897079.)

// What encryption key is the handshake trying to establish?