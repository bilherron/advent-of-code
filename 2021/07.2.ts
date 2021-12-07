import { readFileSync } from 'fs';

const input: number[] = readFileSync('./07.input.txt', 'utf-8').split(',').map(n => +n);

function calcFuel(num: number) {
  let fuel = 0;
  for (let i = 1; i <= num; i++) {
    fuel += i;
  }
  return fuel;
}

const min = Math.min(...input);
const max = Math.max(...input);

let minFuel = Infinity;
for (let i = min; i <= max; i++) {
  let totalFuel = 0;
  for (const hPos of input) {
    const diff = calcFuel(Math.abs(hPos - i));
    totalFuel += diff;
  }
  if (totalFuel < minFuel) {
    minFuel = totalFuel;
  }
}

console.log(minFuel);