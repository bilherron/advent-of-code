import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8').split('\n')
const puzzleInput = readFileSync('./input.txt', 'utf-8').split('\n')

type OctopusGridType = number[][];

class OctopusGrid {
  grid: OctopusGridType;

  constructor(grid: OctopusGridType) {
    this.grid = grid;
  }

  step() {
    this.grid = this.grid.map(row => row.map(o => o + 1));
    let flasherDetected = true;
    while (flasherDetected) {
      flasherDetected = this.checkForFlashers();
    }
    // this.printOctoGrid();
  }

  addOneToNeighbors(x: number, y: number) {
    if (this.grid[y - 1] !== undefined && this.grid[y - 1][x - 1]) this.grid[y - 1][x - 1] += 1;
    if (this.grid[y - 1] !== undefined && this.grid[y - 1][x]) this.grid[y - 1][x] += 1;
    if (this.grid[y - 1] !== undefined && this.grid[y - 1][x + 1]) this.grid[y - 1][x + 1] += 1; 
    if (this.grid[y][x - 1]) this.grid[y][x - 1] += 1;
    if (this.grid[y][x + 1]) this.grid[y][x + 1] += 1; 
    if (this.grid[y + 1] !== undefined && this.grid[y + 1][x - 1]) this.grid[y + 1][x - 1] += 1;
    if (this.grid[y + 1] !== undefined && this.grid[y + 1][x]) this.grid[y + 1][x] += 1;
    if (this.grid[y + 1] !== undefined && this.grid[y + 1][x + 1]) this.grid[y + 1][x + 1] += 1; 
  }

  checkForFlashers() {
    let flasherDetected = false;
    this.grid.forEach((row, y) => {
      row.forEach((octopus, x) => {
        if (octopus > 9) {
          flasherDetected = true;
          this.addOneToNeighbors(x, y);
          this.grid[y][x] = 0;
        }
      });
    });
    return flasherDetected;
  }

  printOctoGrid() {
    this.grid.forEach((row) => {
      console.log(row.join(''));
    });
    console.log('+'.repeat(12));
  }
}

let flashSum = 0;
let octoGrid = new OctopusGrid(puzzleInput.map(row => row.split('').map(n => +n)));
for (let i = 1; i <= 100; i++) {
  octoGrid.step();
  flashSum += octoGrid.grid.flat().reduce((acc, octo) => {
    return (octo === 0) ? acc + 1 : acc;
  }, 0);
}
console.log(flashSum);