import { readFileSync } from 'fs';

const input: number[] = readFileSync('./07.input.txt', 'utf-8').split(',').map(n => +n);

const min = Math.min(...input);
const max = Math.max(...input);

let minFuel = Infinity;
for (let i = min; i <= max; i++) {
  let totalFuel = 0;
  for (const hPos of input) {
    const diff = Math.abs(hPos - i);
    totalFuel += diff;
  }
  if (totalFuel < minFuel) {
    minFuel = totalFuel;
  }
}

console.log(minFuel);