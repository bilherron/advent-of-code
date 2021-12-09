import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8');
const puzzleInput = readFileSync('./input.txt', 'utf-8');

const floorMap = puzzleInput.split('\n').map(row => row.split('').map(n => parseInt(n, 10)));
const lowPoints: number[][] = [];

floorMap.forEach((row, rowIndex) => {
  row.forEach((square, squareIndex) => {
    const up = (rowIndex === 0) ? 10 : floorMap[rowIndex - 1][squareIndex];
    const down = (rowIndex === (floorMap.length - 1)) ? 10 : floorMap[rowIndex + 1][squareIndex];
    const left = (squareIndex === 0) ? 10 : floorMap[rowIndex][squareIndex - 1];
    const right = (squareIndex === (row.length - 1)) ? 10 : floorMap[rowIndex][squareIndex + 1];
    
    if (
      up > square &&
      down > square &&
      left > square &&
      right > square
      ) {
        lowPoints.push([squareIndex, rowIndex]);
      }
  });
});

const basinSizes = lowPoints.map(lowPoint => mapBasin(lowPoint));
basinSizes.sort((a, b) => a - b).reverse();
const answer = basinSizes[0] * basinSizes[1] * basinSizes[2];
console.log(answer);


function mapBasin(squareCoordinates: number[]) {
  const [x, y] = squareCoordinates;
  const checkedSquares = new Set();
  const squaresToCheck = [];
  
  // start with the lowpoint
  // get its neighbors that are not 9, add them to the list to check
  squaresToCheck.push(...nonNineNeighbors(squareCoordinates));
  // add the lowpoint to the set of checked squares
  checkedSquares.add(`${x},${y}`);
  while (squaresToCheck.length !== 0) {
    // pop the first point off the list to check
    const neighbor = squaresToCheck.shift();
    // get its neighbors that are not 9 and not in the set of checked squares, add them to the list to check
    for (const nnn of nonNineNeighbors(neighbor!)) {
      if (!checkedSquares.has(`${nnn[0]},${nnn[1]}`)) {
        squaresToCheck.push(nnn);
      }
    }
    // add point to checked squares
    checkedSquares.add(`${neighbor![0]},${neighbor![1]}`);
  }
  // repeat until list to check is empty
  
  return checkedSquares.size;
}

function nonNineNeighbors(squareCoordinates: number[]) {
  const neighbors = getNeighbors(squareCoordinates);
  const nonNineNeighbors = [];
  if (neighbors.up && getSquareValue(neighbors.up) !== 9) nonNineNeighbors.push(neighbors.up);
  if (neighbors.down && getSquareValue(neighbors.down) !== 9) nonNineNeighbors.push(neighbors.down);
  if (neighbors.left && getSquareValue(neighbors.left) !== 9) nonNineNeighbors.push(neighbors.left);
  if (neighbors.right && getSquareValue(neighbors.right) !== 9) nonNineNeighbors.push(neighbors.right);
  return nonNineNeighbors;
}

interface Neighbors {
  up: number[] | null
  down: number[] | null
  left: number[] | null
  right: number[] | null
}
function getNeighbors(squareCoordinates: number[]): Neighbors {
  const [x, y] = squareCoordinates;
  const up = (y === 0) ? null : [x, (y - 1)];
  const down = (y === (floorMap.length - 1)) ? null : [x, (y + 1)];
  const left = (x === 0) ? null : [(x - 1), y];
  const right = (x === (floorMap[0].length - 1)) ? null : [(x + 1), y];

  return { up, down, left, right };
}

function getSquareValue(squareCoordinates: number[]) {
  const [x, y] = squareCoordinates;
  return floorMap[y][x];
}