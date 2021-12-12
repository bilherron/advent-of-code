import { readFileSync } from 'fs';

const shortExampleInput = readFileSync('./short.example.input.txt', 'utf-8').split('\n')
const exampleInput = readFileSync('./example.input.txt', 'utf-8').split('\n')
const puzzleInput = readFileSync('./input.txt', 'utf-8').split('\n')

const segments = puzzleInput.map(raw => raw.split('-'));

const destinations: { [index: string]: Set<string>} = {};

for (const segment of segments) {
  const [left, right] = segment;
  
  if (destinations[left] === undefined) {
    destinations[left] = new Set();
  }
  if (destinations[right] === undefined) {
    destinations[right] = new Set();
  }
  destinations[left].add(right);
  destinations[right].add(left);
}

let paths = [['start']];
const startTime = Date.now();
let counter = 0;
while (!allDone(paths)) {
  const stepStartTime = Date.now();
  paths = nextStep(paths);
  counter++;
  console.log(counter, Date.now() - stepStartTime, Date.now() - startTime);
}
console.log(paths.length);


function isSmallCave(cave: string) {
  return cave.toLowerCase() === cave;
}

function nextStep(paths: string[][]) {
  paths.forEach((path, index) => {
    const currentCave = path[path.length - 1];
    if (currentCave !== 'end') {
      const alreadyVisitedSmallCave = path.some((cave, index) => {
        return isSmallCave(cave) && (path.indexOf(cave, index + 1) > -1);
      });
      const nextOptions = destinations[currentCave];
      const updatedPaths: string[][] = [];
      for (const nextOption of nextOptions) {
        if (nextOption === 'start') continue;
        const newPath = [...path];
        const caveIsSmall = isSmallCave(nextOption);
        if (
          caveIsSmall && 
          newPath.includes(nextOption) && 
          alreadyVisitedSmallCave
        ) {
          continue;
        }
        newPath.push(nextOption)
        updatedPaths.push(newPath);
      }
      paths.splice(index, 1, ...updatedPaths);
    }

  });
  return paths;
}

function allDone(paths: string[][]) {
  return paths.every((path) => path[path.length - 1] === 'end');
}
