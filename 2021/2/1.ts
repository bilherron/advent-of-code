import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8').split('\n');
const puzzleInput = readFileSync('./input.txt', 'utf-8').split('\n');

const directions = puzzleInput.map(item => {
  const [direction, amt] = item.split(' ');
  return { direction, amount: parseInt(amt, 10) };
});

let horPos = 0;
let verPos = 0;

for (const { direction, amount } of directions) {
  switch (direction) {
    case 'forward':
      horPos += amount;
      break;
    case 'down':
      verPos += amount;
      break;
    case 'up':
      verPos -= amount;
      break;
  }
}

console.log(horPos * verPos);