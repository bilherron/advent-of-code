import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8').split('\n');
const puzzleInput = readFileSync('./input.txt', 'utf-8').split('\n');

const measurements = puzzleInput.map(m => +m);
let increases = 0;
measurements.forEach((measurement, index) => {
  if (index === 0) return;
  if (measurement > measurements[index - 1]) {
    increases += 1;
  }
});
console.log(increases);