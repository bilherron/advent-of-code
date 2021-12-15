import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8').split('\n')
const puzzleInput = readFileSync('./input.txt', 'utf-8').split('\n')

const exampleChain = 'NNCB';
const puzzleChain = 'HBHVVNPCNFPSVKBPPCBH';

const rules: { [index: string]: string } = {};
for (const rule of puzzleInput) {
  const [match, insertion] = rule.split(' -> ');
  rules[match] = insertion;
}
let newChain = puzzleChain;
for (let count = 1; count <= 10; count++) {
  newChain = makeInsertions(newChain);
}
const elementCounts = Object.values(countElements(newChain));
console.log(Math.max(...elementCounts) - Math.min(...elementCounts));


function makeInsertions(polymerChain: string) {
  let newPolymerString = '';
  const pairs = chunkPairs(polymerChain);
  for (const pair of pairs) {
    newPolymerString = newPolymerString + pair[0] + rules[pair];
  }
  newPolymerString += polymerChain.slice(-1);
  return newPolymerString;
}

function chunkPairs(polymerChain: string) {
  const chunkedPairs: string[] = [];
  let numPairs = polymerChain.length - 1;
  for (let i = 0; i < numPairs; i++) {
    chunkedPairs.push(polymerChain[i]+polymerChain[i+1]);
  }
  return chunkedPairs;
}

function countElements(polymerChain: string) {
  const elementCounts: { [index: string]: number } = {};
  polymerChain.split('').forEach((element) => {
    if (!elementCounts[element]) {
      elementCounts[element] = 0;
    }
    elementCounts[element]++;
  })
  return elementCounts;
}