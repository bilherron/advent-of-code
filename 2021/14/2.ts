import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8').split('\n')
const puzzleInput = readFileSync('./input.txt', 'utf-8').split('\n')
const exampleChain = 'NNCB';
const puzzleChain = 'HBHVVNPCNFPSVKBPPCBH';

const input = { chain: puzzleChain, rules: puzzleInput };
const NUM_STEPS = 40;

const rules: { [index: string]: string } = {};
for (const rule of input.rules) {
  const [match, insertion] = rule.split(' -> ');
  rules[match] = insertion;
}

const emptyPairCount: { [index: string]: number } = {};
for (const pair of Object.keys(rules)) {
  emptyPairCount[pair] = 0;
}

let pairCounts = Object.assign({}, emptyPairCount);

const initialPairs = chunkPairs(input.chain);
for (const pair of initialPairs) {
  pairCounts[pair] += 1;
}

for (let count = 1; count <= NUM_STEPS; count++) {
  const newPairCount = Object.assign({}, emptyPairCount);
  for (const pair of Object.keys(pairCounts)) {
    const [leftPair, rightPair] = splitIntoPairs(pair);
    const startPairCount = pairCounts[pair];
    newPairCount[leftPair] += startPairCount;
    newPairCount[rightPair] += startPairCount;
  }
  pairCounts = Object.assign({}, newPairCount);
}
const countedElements = countElements(pairCounts);
const elementCounts = Object.values(countedElements);
console.log(Math.max(...elementCounts) - Math.min(...elementCounts));

function splitIntoPairs(pair: string) {
    const newPolymerString = pair[0] + rules[pair] + pair[1];
    return chunkPairs(newPolymerString);
}

function chunkPairs(polymerChain: string) {
  const chunkedPairs: string[] = [];
  let numPairs = polymerChain.length - 1;
  for (let i = 0; i < numPairs; i++) {
    chunkedPairs.push(polymerChain[i]+polymerChain[i+1]);
  }
  return chunkedPairs;
}

function countElements(pairCountObject: { [index: string]: number }) {
  const elementCounts: { [index: string]: number } = {};
  for (const pair of Object.keys(pairCountObject)) {
    const [leftElement, rightElement] = pair.split('');
    if (elementCounts[rightElement] === undefined) {
      elementCounts[rightElement] = 0;
    }
    // the left element will be counted as the right element of its neighbor
    elementCounts[rightElement] += pairCountObject[pair];
  }
  // add one more for the first element because we only counted the right side of all the pairs
  const firstLetter = input.chain[0];
  elementCounts[firstLetter] += 1;
  return elementCounts;
}