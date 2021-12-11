import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8').split('\n')
const puzzleInput = readFileSync('./input.txt', 'utf-8').split('\n')

type OctopusGrid = number[][];

class OctopuGrid {
  grid: OctopusGrid;
  octopusCount: number;

  constructor(grid: OctopusGrid) {
    this.grid = grid;
    this.octopusCount = grid.length * grid[0].length;
  }

  step() {
    this.grid = this.grid.map(row => row.map(o => o + 1));
    let flasherDetected = true;
    while (flasherDetected) {
      flasherDetected = this.checkForFlashers();
    }
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

const octoGrid = new OctopuGrid(puzzleInput.map(row => row.split('').map(n => +n)));
let i = 1;
while (true) {
  octoGrid.step();
  // octoGrid.printOctoGrid();
  const flashCount = octoGrid.grid.flat().reduce((acc, octo) => {
    return (octo === 0) ? acc + 1 : acc;
  }, 0);
  if (flashCount === octoGrid.octopusCount) {
    console.log(i);
    break;
  }
  i++;
}