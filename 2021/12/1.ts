import { readFileSync } from 'fs';

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

while (!allDone(paths)) {
  paths = nextStep(paths);
}
console.log(paths.length);


function nextStep(paths: string[][]) {
  paths.forEach((path, index) => {
    const currentCave = path[path.length - 1];
    if (currentCave !== 'end') {
      const nextOptions = destinations[currentCave];
      const updatedPaths: string[][] = [];
      for (const nextOption of nextOptions) {
        const newPath = [...path];
        const isSmallCave = (nextOption.toLowerCase() === nextOption);
        if (isSmallCave && newPath.includes(nextOption)) {
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