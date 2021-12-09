import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8');
const puzzleInput = readFileSync('./input.txt', 'utf-8');

const floorMap = puzzleInput.split('\n').map(row => row.split('').map(n => parseInt(n, 10)));

const lowPoints: number[] = [];

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
        lowPoints.push(square);
      }
  });
});

const riskLevel = lowPoints.reduce((acc, lp) => {
  return acc + lp + 1;
}, 0);
console.log(riskLevel);