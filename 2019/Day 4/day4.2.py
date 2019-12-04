import re

candidates = [str(i) for i in range(272091,815432)]

def ascendingDigitCheck(num):
    leftDigit = int(num[0])
    for d in num:
        if int(d) < leftDigit:
            return False
        else:
            leftDigit = int(d)
    return True

def hasTwoAndOnlyTwoAdjecentSameDigits(num):
    twoAdjacentDigitRegex = re.compile(r'(\d)\1')
    doubles = twoAdjacentDigitRegex.findall(num)
    threeAdjacentDigitRegex = re.compile(r'(\d)\1\1')
    triples = threeAdjacentDigitRegex.findall(num)
    diff = list(set(doubles) - set(triples))
    return (len(diff) > 0)

candidates = list(filter(hasTwoAndOnlyTwoAdjecentSameDigits, candidates))
candidates = list(filter(ascendingDigitCheck, candidates))

print(len(candidates))
