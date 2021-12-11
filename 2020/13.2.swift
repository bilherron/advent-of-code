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
  busTimes.append(index + 1)
  busNums.append(bus)
}
// print(busTimes, busNums)
// print(crt(num:busTimes, rem:busNums))
print(buses)
print(busNums, busTimes)
print(crt(busTimes,busNums))


// let a = [2,3,2]
// let n = [3,5,7]

// let x = crt(a,n)

// print(x)

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

/*
 * Function: euclid
 * Usage: (r,s) = euclid(m,n)
 * --------------------------
 * The extended Euclidean algorithm subsequently performs
 * Euclidean divisions till the remainder is zero and then
 * returns the Bézout coefficients r and s.
 */

func euclid(_ m:Int, _ n:Int) -> (Int,Int) {
    if m % n == 0 {
        return (0,1)
    } else {
        let rs = euclid(n % m, m)
        let r = rs.1 - rs.0 * (n / m)
        let s = rs.0

        return (r,s)
    }
}

/*
 * Function: gcd
 * Usage: x = gcd(m,n)
 * -------------------
 * The greatest common divisor of two numbers a and b
 * is expressed by ax + by = gcd(a,b) where x and y are
 * the Bézout coefficients as determined by the extended
 * euclidean algorithm.
 */

func gcd(_ m:Int, _ n:Int) -> Int {
    let rs = euclid(m, n)
    return m * rs.0 + n * rs.1
}

/*
 * Function: coprime
 * Usage: truth = coprime(m,n)
 * ---------------------------
 * If two values are coprime, their greatest common
 * divisor is 1.
 */

func coprime(_ m:Int, _ n:Int) -> Bool {
    return gcd(m,n) == 1 ? true : false
}

coprime(14,26)
//coprime(2,4)

/*
 * Function: crt
 * Usage: x = crt(a,n)
 * -------------------
 * The Chinese Remainder Theorem supposes that given the
 * integers n_1...n_k that are pairwise co-prime, then for
 * any sequence of integers a_1...a_k there exists an integer
 * x that solves the system of linear congruences:
 *
 *   x === a_1 (mod n_1)
 *   ...
 *   x === a_k (mod n_k)
 */

func crt(_ a_i:[Int], _ n_i:[Int]) -> Int {
    // There is no identity operator for elements of [Int].
    // The offset of the elements of an enumerated sequence
    // can be used instead, to determine if two elements of the same
    // array are the same.
    let divs = n_i.enumerated()

    // Check if elements of n_i are pairwise coprime divs.filter{ $0.0 < n.0 }
    divs.forEach{
        n in divs.filter{ $0.0 < n.0 }.forEach{
            assert(coprime(n.1, $0.1))
        }
    }

    // Calculate factor N
    let N = n_i.map{$0}.reduce(1, *)

    // Euclidean algorithm determines s_i (and r_i)
    var s:[Int] = []

    // Using euclidean algorithm to calculate r_i, s_i
    n_i.forEach{ s += [euclid($0, N / $0).1] }

    // Solve for x
    var x = 0
    a_i.enumerated().forEach{
        x += $0.1 * s[$0.0] * N / n_i[$0.0]
    }

    // Return minimal solution
    return x % N
}
