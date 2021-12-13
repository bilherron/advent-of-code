import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8').split('\n')
const puzzleInput = readFileSync('./input.txt', 'utf-8').split('\n')
const input = puzzleInput;

let maxX = getMaxDimension(input, 0);
let maxY = getMaxDimension(input, 1);
let paper: number[][] = [];
for (let i = 0; i <= maxY; i++) {
  paper[i] = new Array(maxX + 1).fill(0);
}
// fill in initial dots
for (const coord of input) {
  const [x, y] = coord.split(',').map(n => +n);
  paper[y][x] = 1;
}
// fold('y', 7);
fold('x', 655);
console.log(paper.flat().reduce((acc, cur) => acc + cur, 0));

function fold(dim: 'x' | 'y', value: number) {
  if (dim === 'y') {
    let rowCount = 0;
    for (const row of paper) {
      if (rowCount === value) break;
      for (let x = 0; x < row.length; x++) {
        if (paper[paper.length - 1 - rowCount][x] === 1) {
          paper[rowCount][x] = 1;
        }
      }
      rowCount++;
    }
    // remove fold and all rows past the fold
    paper.splice(value);
  } else {
    paper.forEach((row, y) => {
      row.forEach((square, x) => {
        if (x < value) {
          if (paper[y][row.length - x] === 1) {
            paper[y][x] = 1;
          }
        }
      })
    });
    paper.forEach((r, index) => {
      // remove fold and all columns past the fold
      paper[index].splice(value);
    })
  }
}

function printPaper() {
  for (const row of paper) {
    console.log(row.join(''));
  }
}

function getMaxDimension(input: string[], arrayIndex: number) {
  return Math.max(...input.map(c => c.split(',')).map(n => +n[arrayIndex]));
}