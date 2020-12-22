import Foundation

// https://adventofcode.com/2020/day/21
let input = importPuzzleInput("./21.input.txt")
let testInput = importPuzzleInput("./21.input.test.txt")

let test = false
let foods = (test) ? testInput.components(separatedBy: "\n") : input.components(separatedBy: "\n")

var allergenIngredients = [String: Set<String>]()
var allIngredients = Set<String>()
var foodIngredients = [Set<String>]()

for food in foods {
  let foodParts = food.components(separatedBy: " (contains ")
  let ingredients = Set(foodParts[0].components(separatedBy: " "))
  foodIngredients.append(ingredients)
  let allergens = foodParts[1].replacingOccurrences(of: ")", with: "").components(separatedBy: ", ")

  allIngredients = allIngredients.union(ingredients)
  for allergen in allergens {
    if allergenIngredients[allergen] == nil {
      allergenIngredients[allergen] = Set(ingredients)
    } else {
      allergenIngredients[allergen] = allergenIngredients[allergen]!.intersection(Set(ingredients))
    }
  }
}
func allReduced(_ allergenIngredients: [String: Set<String>]) -> Bool {
  var allReduced = true
  for ai in allergenIngredients {
    if ai.value.count > 1 {
      allReduced = false
    }
  }
  return allReduced
}

while allReduced(allergenIngredients) != true {
  for allergenIngredient in allergenIngredients {
    if allergenIngredient.value.count == 1 {
      for allergenIngredient2 in allergenIngredients {
        if allergenIngredient2.key == allergenIngredient.key {
          continue
        }
        allergenIngredients[allergenIngredient2.key]!.remove(allergenIngredient.value.first ?? "")
      }
    }
  }
}

for allergenIngredient in allergenIngredients {
  allIngredients.remove(allergenIngredient.value.first ?? "")
}

// part 1
var answerCount = 0
for ai in allIngredients {
  for fi in foodIngredients {
    if fi.contains(ai) {
      answerCount += 1
    }
  }
}
print("answer", answerCount)


// part 2
var foodStringArr = [String]()
for sai in allergenIngredients.keys.sorted() {
  foodStringArr.append(allergenIngredients[sai]!.first!)
}
print("answer", foodStringArr.joined(separator: ","))


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
