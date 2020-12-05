import Foundation

let file = "1.input.txt"
do {
    let contents = try String(contentsOfFile: file, encoding: .ascii)
    let entries = contents.components(separatedBy: "\n").map { Int($0)! }

    // part 1
    var stop = false
    for i in 0...(entries.count - 1) {
        for j in 1...(entries.count - 1) {
            let sum = entries[i] + entries[j]
            if sum == 2020 {
                print(entries[i] * entries[j])
                stop = true
                break
            }
        }
        if stop {
            break
        }
    }

    // part 2
    stop = false
    for i in 0...(entries.count - 1) {
        for j in 1...(entries.count - 1) {
            for k in 1...(entries.count - 1) {
                let sum = entries[i] + entries[j] + entries[k]
                if sum == 2020 {
                    print(entries[i] * entries[j] * entries[k])
                    stop = true
                    break
                }
            }
            if stop {
                break
            }
        }
        if stop {
            break
        }
    }
}
catch let error {
    print("Ooops! Something went wrong: \(error)")
}
