import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8').split('\n')
const puzzleInput = readFileSync('./input.txt', 'utf-8').split('\n')
const input = puzzleInput;

type Instructions = {
  dimension: 'y' | 'x'
  amount: number
}

const exampleFolds: Instructions[] = [
  { dimension: 'y', amount: 7 },
  { dimension: 'x', amount: 5 },
];
const puzzleFolds: Instructions[] = [
  { dimension: 'x', amount: 655 },
  { dimension: 'y', amount: 447 },
  { dimension: 'x', amount: 327 },
  { dimension: 'y', amount: 223 },
  { dimension: 'x', amount: 163 },
  { dimension: 'y', amount: 111 },
  { dimension: 'x', amount: 81 },
  { dimension: 'y', amount: 55 },
  { dimension: 'x', amount: 40 },
  { dimension: 'y', amount: 27 },
  { dimension: 'y', amount: 13 },
  { dimension: 'y', amount: 6 },
];
const firstXfold = 655
const firstYfold = 447;

let paper: number[][] =[];
for (let i = 0; i <= (firstYfold * 2); i++) {
  paper[i] = new Array(firstXfold * 2 + 1).fill(0);
}

// fill in initial dots
for (const coord of input) {
  const [x, y] = coord.split(',').map(n => +n);
  paper[y][x] = 1;
}

for (const instruction of puzzleFolds) {
  fold(instruction.dimension, instruction.amount);
}
printPaper();

function fold(dim: 'x' | 'y', value: number) {
  if (dim === 'y') {
    paper.forEach((row, y) => {
      if (y < value) {
        for (let x = 0; x < row.length; x++) {
          if (paper[paper.length - 1 - y][x] === 1) {
            paper[y][x] = 1;
          }
        }
      }
    });
    // remove fold and all rows past the fold
    paper.splice(value);
  } else {
    paper.forEach((row, y) => {
      for (let x = row.length - 1; x > value; x--) {
        if (paper[y][row.length - 1 - x] === 1) {
          paper[y][x] = 1;
        }
      }
    });
    paper.forEach((r, index) => {
      // remove fold and all columns past the fold
      paper[index] = r.slice(value + 1);
    })
  }
}

function printPaper() {
  console.log('-'.repeat(40));
  for (const row of paper) {
    const string = row.reverse().join('').replaceAll('0',' ').replaceAll('1','#');
    console.log(string);
  }
  console.log('-'.repeat(40));
}