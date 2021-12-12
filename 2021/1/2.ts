import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8').split('\n');
const puzzleInput = readFileSync('./input.txt', 'utf-8').split('\n');

const measurements = puzzleInput.map(m => +m);
let increases = 0;
const overflow = measurements.length % 3;
const totalTriplets = measurements.length - overflow;

let previousTriplet = Infinity;
for (let i = 0; i < totalTriplets; i++) {
  if (i+2 >= measurements.length) continue;
  const currentTriplet = measurements[i] + measurements[i+1] + measurements[i+2];
  if (currentTriplet > previousTriplet) increases += 1;
  previousTriplet = currentTriplet;
}

console.log(increases);