import Foundation

// https://adventofcode.com/2020/day/19
let input = importPuzzleInput("./19.input.txt")
let testInput = """
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
"""

let inputParts = input.components(separatedBy: "\n\n")

let rawRules = inputParts[0]
let messages = inputParts[1].components(separatedBy: "\n")

var rules = [Int: String]()

rawRules.components(separatedBy: "\n").forEach { ruleString in
  let parts = ruleString.components(separatedBy: ": ")
  rules[Int(parts[0])!] = String(parts[1]).replacingOccurrences(of: "\"", with: "")
}

var newRules = [Int: String]()
var terminalRules = [Int]()
for rule in rules {
  if rule.value == "a" || rule.value == "b" {
    terminalRules.append(rule.key)
  }
}
let ruleZero = rules[0]!.components(separatedBy: " ")

var intermediateRuleZero = [String]()
for rulePart in ruleZero {
  let rulePartInt = Int(rulePart)!
  let ruleForNum = rules[rulePartInt]!
  if terminalRules.contains(rulePartInt) {
    intermediateRuleZero.append(rulePart)
    continue
  } else {
    intermediateRuleZero.append("(\(ruleForNum))")
  }
}

let modRuleZero = resolveRule(rules[0]!)
let ruleZeroRegex = regexify(modRuleZero)

var matchingMessages = 0
for message in messages {
  if message.range(of: ruleZeroRegex, options: .regularExpression) != nil {
    matchingMessages += 1
  }
}

print("Matching messages:", matchingMessages)

func regexify(_ rule: String) -> String {
  let ruleParts = rule.components(separatedBy: " ")
  var regex = ""
  for part in ruleParts {
    if ["(", ")", "|"].contains(part) {
      regex += String(part)
    } else {
      let intChar = Int(String(part))!
      if terminalRules.contains(intChar) {
        regex += rules[intChar]!
      }
    }
  }
  return "^\(regex)$"
}

func resolveRule(_ rule: String) -> String {
  let ruleParts = rule.components(separatedBy: " ")
  var resolvedRule = [String]()
  for part in ruleParts {
    if ["(", ")", "|"].contains(part) {
      resolvedRule.append(String(part))
    } else {
      let intChar = Int(String(part))!
      if terminalRules.contains(intChar) {
        resolvedRule.append(String(part))
      } else {
        let recurse = resolveRule(rules[intChar]!)
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
