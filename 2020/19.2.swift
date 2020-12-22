import Foundation

// https://adventofcode.com/2020/day/19
let input = importPuzzleInput("./19.input.txt")

let inputParts = input.components(separatedBy: "\n\n")
let messages = inputParts[1].components(separatedBy: "\n")
let rawRules = inputParts[0]

let modifiedRawRules = rawRules
                  .replacingOccurrences(of: "8: 42", with: "8: 42 | 42 8")
                  .replacingOccurrences(of: "11: 42 31", with: "11: 42 31 | 42 11 31")
var modifiedRules = [Int: String]()
modifiedRawRules.components(separatedBy: "\n").forEach { ruleString in
  let parts = ruleString.components(separatedBy: ": ")
  modifiedRules[Int(parts[0])!] = String(parts[1]).replacingOccurrences(of: "\"", with: "")
}

var terminalRules = [Int]()
for rule in modifiedRules {
  if rule.value == "a" || rule.value == "b" {
    terminalRules.append(rule.key)
  }
}

var resolvedRules = [Int: String]()
var resolvedRegex = [Int: String]()

let rule42 = resolveRule(modifiedRules[42]!, 42, [Int]())
let regex42 = regexify(rule42)
let rule31 = resolveRule(modifiedRules[31]!, 31, [Int]())
let regex31 = regexify(rule31)
var matchingMessages = 0

for message in messages {
  for i in 1...5 {
    let fullRegex = "^(\(regex42)){1,}(\(regex42)){\(i)}(\(regex31)){\(i)}$"
    if message.range(of: fullRegex, options: .regularExpression) != nil {
      matchingMessages += 1
      break
    }
  }
}

print("Matching messages:", matchingMessages)

func regexify(_ rule: String) -> String {
  if rule == "a" || rule == "b" {
    return rule
  }
  let ruleParts = rule.components(separatedBy: " ")
  var regex = ""
  for part in ruleParts {
    if ["(", ")", "|", "x"].contains(part) {
      regex += String(part)
    } else {
      let intChar = Int(String(part))!
      regex += modifiedRules[intChar]!
    }
  }
  return regex
}

func resolveRule(_ rule: String, _ ruleNum: Int, _ recursor: [Int]) -> String {
  if recursor.contains(ruleNum) {
    return "x"
  }
  var recurseCounter = recursor
  recurseCounter.append(ruleNum)
  if rule == "a" || rule == "b" {
    return rule
  }
  let ruleParts = rule.components(separatedBy: " ")
  var resolvedRule = [String]()
  for part in ruleParts {
    if ["(", ")", "|", "x"].contains(part) {
      resolvedRule.append(String(part))
    } else {
      let intChar = Int(String(part))!
      if terminalRules.contains(intChar) {
        resolvedRule.append(String(part))
      } else if resolvedRules.keys.contains(intChar) {
        resolvedRule.append("( \(resolvedRules[intChar]!) )")
      } else {
        let recurse = resolveRule(modifiedRules[intChar]!, intChar, recurseCounter)
        resolvedRules[intChar] = recurse
        resolvedRule.append("( \(recurse) )")
      }
    }
  }
  return resolvedRule.joined(separator: " ")
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
