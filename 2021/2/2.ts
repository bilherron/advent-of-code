import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8').split('\n');
const puzzleInput = readFileSync('./input.txt', 'utf-8').split('\n');

const directions = puzzleInput.map(item => {
  const [direction, amt] = item.split(' ');
  return { direction, amount: parseInt(amt, 10) };
});

let horPos = 0;
let depth = 0;
let aim = 0;

for (const { direction, amount } of directions) {
  switch (direction) {
    case 'forward':
      horPos += amount;
      depth += (aim * amount);
      break;
    case 'down':
      aim += amount;
      break;
    case 'up':
      aim -= amount;
      break;
  }
}

console.log(horPos * depth);