import Foundation

let input = "4.input.txt"
var validPassportCountPart1 = 0
var validPassportCountPart2 = 0
do {
    let passportBatch = try String(contentsOfFile: input, encoding: .ascii)
    let passports = passportBatch.components(separatedBy: "\n\n")
    for i in 0...(passports.count - 1) {
        let passport = passports[i]
                                .replacingOccurrences(of: "\n", with: ",")
                                .replacingOccurrences(of: " ", with: ",")
                                .components(separatedBy: ",")
        if checkFields(passport: passport) {
            validPassportCountPart1 += 1
        }
        if checkFields(passport: passport) && validateFields(passport: passport) {
            validPassportCountPart2 += 1
        }
    }
    // Part 1
    print(validPassportCountPart1)

    // Part 2
    print(validPassportCountPart2)
}
catch let error {
    print(error)
}

func checkFields(passport: [String]) -> Bool {
    if passport.count == 8 {
        // always valid: all fields are present
        return true
    }
    if passport.count < 7 {
        // always invalid: passport is missing more than 1 field
        return false
    }
    var passportDictionary: [String: String] = [:]
    for i in 0...passport.count - 1 {
        let passportKV = passport[i].components(separatedBy: ":")
        let (key, value) = (passportKV[0], passportKV[1])
        passportDictionary[key] = value
    }
    return (passportDictionary["cid"] == nil)
}

func validateFields(passport: [String]) -> Bool {
    var passportDictionary: [String: String] = [:]
    for i in 0...passport.count - 1 {
        let passportKV = passport[i].components(separatedBy: ":")
        let (key, value) = (passportKV[0], passportKV[1])
        passportDictionary[key] = value

        switch key {
            case "byr":
                if Int(value)! < 1920 || Int(value)! > 2002 {
                    return false
                }
            case "iyr":
                if Int(value)! < 2010 || Int(value)! > 2020 {
                    return false
                }
            case "eyr":
                if Int(value)! < 2020 || Int(value)! > 2030 {
                    return false
                }
            case "hgt":
                if !value.hasSuffix("in") && !value.hasSuffix("cm") {
                    return false
                }
                let numValue = value.prefix(through:value.index(value.endIndex, offsetBy: -3))
                if value.hasSuffix("in") {
                    if Int(numValue)! < 59 || Int(numValue)! > 76 {
                        return false
                    }
                }
                if value.hasSuffix("cm") {
                    if Int(numValue)! < 150 || Int(numValue)! > 193 {
                        return false
                    }
                }
            case "hcl":
                let regex = try? NSRegularExpression(pattern: "^#[a-f0-9]{6}$", options: [])
                if regex?.numberOfMatches(in: value, options: [], range: NSRange(location: 0, length: value.count)) == 0 {
                    return false
                }
            case "ecl":
            let eyeColors: Set = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
            if !eyeColors.contains(value) {
                return false
            }
            case "pid":
                let regex = try? NSRegularExpression(pattern: "^[0-9]{9}$")
                if regex?.numberOfMatches(in: value, options: [], range: NSRange(location: 0, length: value.count)) == 0 {
                    return false
                }
            default:
                continue
        }
    }
    return true
}