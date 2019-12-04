import math

def calculateFuel(mass):
    # return int(math.floor(int(mass)/3)) - 2
    return int(mass) // 3 - 2

totalFuel = 0
with open('input.txt', 'r') as input:
    for line in input:
        moduleFuel = calculateFuel(line.strip())
        totalFuel += moduleFuel
        while True:
            neededFuel = calculateFuel(moduleFuel)
            if neededFuel > 0:
                totalFuel += neededFuel
                moduleFuel = neededFuel
            else:
                break

print(totalFuel)

