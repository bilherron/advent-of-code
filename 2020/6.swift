import Foundation

let input = "6.input.txt"
do {
    let groups = try String(contentsOfFile: input, encoding: .ascii).components(separatedBy: "\n\n")
    
    var groupTotals = groups.map {
        groupTotal(group: $0)
    }
    print(groupTotals.reduce(0, +))

    groupTotals = groups.map {
        groupAllTotal(group: $0)
    }
    print(groupTotals.reduce(0, +))

}
catch let error {
    print(error)
}

func groupTotal(group: String) -> Int {
    let answers = group.replacingOccurrences(of: "\n", with: "")
    
    return Set(answers).count
}

func groupAllTotal(group: String) -> Int {
    let groupSize = group.components(separatedBy: "\n").count
    let allAnswers = group.replacingOccurrences(of: "\n", with: "")
    var counter = 0
    
    for question in Set(allAnswers) {
        let qCount = allAnswers.components(separatedBy: String(question)).count - 1
        if qCount == groupSize {
            counter += 1
        }
    }
    return counter
}