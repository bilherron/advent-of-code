import Foundation

let file = "2.input.txt"
do {
    let contents = try String(contentsOfFile: file, encoding: .ascii)
    let entries = contents.components(separatedBy: "\n")
    var goodCount = 0
    for i in 0...(entries.count - 1) {
        var policyNumLow: Substring
        var policyNumHigh: Substring
        var password: Substring
        var policyAlpha: Substring
        let pattern = #"(\d+)-(\d+) (\w): (\w+)$"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        if let match = regex?.firstMatch(in: entries[i], options: [], range: NSRange(location: 0, length: entries[i].utf8.count)) {
            if let policyNumLowRange = Range(match.range(at: 1), in: entries[i]) {
                policyNumLow = entries[i][policyNumLowRange]
                if let policyNumHighRange = Range(match.range(at: 2), in: entries[i]) {
                    policyNumHigh = entries[i][policyNumHighRange]
                    if let policyAlphaRange = Range(match.range(at: 3), in: entries[i]) {
                        policyAlpha = entries[i][policyAlphaRange]
                        if let passwordRange = Range(match.range(at: 4), in: entries[i]) {
                            password = entries[i][passwordRange]
                            let policyOne = password[password.index(password.startIndex, offsetBy: Int(policyNumLow)! - 1)]
                            let policyTwo = password[password.index(password.startIndex, offsetBy: Int(policyNumHigh)! - 1)]
                            let pOneMatch = String(policyOne) == String(policyAlpha)
                            let pTwoMatch = String(policyTwo) == String(policyAlpha)
                            if (pOneMatch || pTwoMatch) && (policyOne != policyTwo) {
                                  goodCount += 1
                              }
                        }
                    }
                }
            }
        }
    }
    print(goodCount)
}
catch let error {
    print("Ooops! Something went wrong: \(error)")
}
