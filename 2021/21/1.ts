const exampleInput = [4,8];
const puzzleInput = [2,8];

class DeterministicDie {
  value = 0;
  rollCount = 0;

  constructor() {
    this.value = 0;
  }

  roll() {
    this.rollCount += 1;
    if (this.value === 100) {
      this.value = 0;
    }
    this.value += 1;
    return this.value;
  }
}

class Player {
  position: number;
  die: DeterministicDie;
  score = 0;
  winner = false;
  
  constructor(startingPosition: number, gameDie: DeterministicDie) {
    this.position = startingPosition;
    this.die = gameDie;
  }

  takeTurn() {
    let moveDistance = 0;
    for (const rollNumber of [1,2,3]) {
      moveDistance += this.die.roll();
    }
    const newPosition = ((this.position + moveDistance) % 10) || 10;
    this.position = newPosition;
    this.score += this.position;

    if (this.score >= 1000) {
      this.winner = true;
    }
  }
}

const gameDie = new DeterministicDie();
const playerOne = new Player(puzzleInput[0], gameDie);
const playerTwo = new Player(puzzleInput[1], gameDie);

let loserScore = 0;
while (true) {
  playerOne.takeTurn();
  console.log(`playerOne score ${playerOne.score}, rollCount ${gameDie.rollCount}`)
  if (playerOne.winner) {
    loserScore = playerTwo.score;
    break;
  }
  playerTwo.takeTurn();
  console.log(`playerTwo score ${playerTwo.score}, rollCount ${gameDie.rollCount}`)
  if (playerTwo.winner) {
    loserScore = playerOne.score;
    break;
  }
}

console.log(loserScore * gameDie.rollCount);