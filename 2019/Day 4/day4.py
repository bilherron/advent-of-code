import re

input = [str(i) for i in range(272091,815432)]

def ascendingDigitCheck(num):
    leftDigit = int(num[0])
    for d in num:
        if int(d) < leftDigit:
            return False
        else:
            leftDigit = int(d)
    return True

adjacentDigitRegex = re.compile(r'(\d)\1')
candidates = list(filter(adjacentDigitRegex.search, input))
candidates = list(filter(ascendingDigitCheck, candidates))

print(len(candidates))

