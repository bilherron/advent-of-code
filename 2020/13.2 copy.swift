import Foundation

// https://adventofcode.com/2020/day/13
let testInput = importPuzzleInput("./13.input.test.txt")
let input = importPuzzleInput("./13.input.txt")

var notes = testInput.components(separatedBy: "\n")
notes = input.components(separatedBy: "\n")
notes[1] = "7,13,x,x,59,x,31,19"
// notes[1] = "17,x,13,19"
notes[1] = "67,7,59,61"
notes[1] = "67,x,7,59,61"
notes[1] = "67,7,x,59,61"
// notes[1] = "67,7,59,x,61"
// notes[1] = "1789,37,47,1889"
let buses = notes[1].replacingOccurrences(of: "x", with: "1").components(separatedBy: ",").map { Int($0)! }

var stop = false
let firstBus = buses[0]
var earliestTimestamp = buses[0]
var increasingBuses = buses
// while stop == false {
//   for (index, bus) in increasingBuses.enumerated() {
//     print(increasingBuses)
//     // if index == 0 { continue }
//     if bus == 0 {
//       // ignore
//     } else {
//       if increasingBuses[index] % (firstBus + index) != 0 {
//         for (index, bus) in increasingBuses.enumerated() {
//           increasingBuses[index] += buses[index]
//         }
//         break
//       }
//       if index == (buses.count - 1) {
//         stop = true
//       }
//     }
//   }
// }
// print(increasingBuses)

// var multiplier = 1
// var answers = [Int]()
// while stop == false {
//   let test = buses[0]
//   var allMatch = true
//   for (index, bus) in buses.enumerated() {
//     // let testValue = ((test * multiplier) + index) % bus
//     // print("test \(test) * multiplier \(multiplier) + index \(index) % bus \(bus) == \(testValue)")
//     if ((test * multiplier) + index) % bus != 0 {
//       allMatch = false
//     }
//   }
//   earliestTimestamp = multiplier * buses[0]
//   multiplier += 1
//   if allMatch {
//     answers.append(earliestTimestamp)
//   }
//   if answers.count == 5 {
//     stop = true
//   }
// }
// print(answers)
// 3,162,341 = bus numbers times each other


let product = buses.reduce(1) { $0 * $1 }
// var product3 = 1
// print(product, product/buses.max()!)

var busTimes = [Int]()
var busNums = [Int]()
for (index, bus) in buses.enumerated() {
  busTimes.append(index)
  busNums.append(bus)
}
// print(busTimes, busNums)
// print(crt(num:busTimes, rem:busNums))
print(busNums, busTimes)
print(crt(num:busNums, rem:busTimes))



func crt(num: [Int], rem: [Int]) -> Int {
  // print("calling crt")
  var sum = 0;
  let prod = num.reduce(1) { $0 * $1 };

  for i in num.indices {
    if num[i] == 0 {
      continue
    }
    let (ni, ri) = (num[i], rem[i]);
    print("p = Int(floor(\(Double(prod)) / \(Double(ni))))")
    let p = Int(floor(Double(prod) / Double(ni)));

    sum += ri * p * mulInv(a: p, b: ni);
  }
  return sum % prod;
}

func mulInv(a: Int, b: Int) -> Int {
  print("calling mulInv(\(a), \(b))")
  var aa = a, bb = b
  let b0 = b;
  var (x0, x1) = (0, 1);
  print("aa \(aa) bb \(bb) (x0, x1) (\(x0), \(x1))")
  if (bb == 1) {
    return 1;
  }
  while (aa > 1) {
    let q = floor(Double(aa) / Double(bb));
    print("aa \(aa) bb \(bb) q \(q)")
    (aa, bb) = (bb, aa % bb);
    (x0, x1) = (x1 - Int(q) * x0, x0);
  }
  if (x1 < 0) {
    x1 += b0;
  }
  return x1;
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
