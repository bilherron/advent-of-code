(() => {
  let puzzleInput = [4,8];
  puzzleInput = [2,8];

  class Player {
    position: number;
    score = 0;
    number: number;
    
    constructor(playerNumber: number, startingScore: number, startingPosition: number) {
      this.position = startingPosition;
      this.number = playerNumber;
      this.score = startingScore;
    }

    move(rollResult: number) {
      const newPosition = ((this.position + rollResult) % 10) || 10;
      this.position = newPosition;
      this.score += this.position;
    }

    winner() {
      return this.score >= 21;
    }
  }

  class Universe {
    playerOne: Player;
    playerTwo: Player;
    id: number;
    multiplier: number;

    // a universe has a starting state of 2 players with a certain score
    constructor(playerOne: Player, playerTwo: Player, multiplier: number) {
      universeNumber++;
      this.playerOne = playerOne;
      this.playerTwo = playerTwo;
      this.id = universeNumber;
      this.multiplier = multiplier;
    }

    winner() {
      if (this.playerOne.winner()) {
        return 1;
      }
      if (this.playerTwo.winner()) {
        return 2;
      }
    }
    play() {
      if (this.winner() !== undefined) return;
      for (let roll1 = 1; roll1 <= 3; roll1++) {
        for (let roll2 = 1; roll2 <= 3; roll2++) {
          for (let roll3 = 1; roll3 <= 3; roll3++) {
            const playerOneClone = clonePlayer(this.playerOne);
            playerOneClone.move(roll1 + roll2 + roll3);
            if (playerOneClone.winner()) {
              // no need to make 27 more universes, right?
              const newUniverse = new Universe(playerOneClone, clonePlayer(this.playerTwo), this.multiplier);
              universes.push(newUniverse);
              continue;
            }
            for (let roll4 = 1; roll4 <= 3; roll4++) {
              for (let roll5 = 1; roll5 <= 3; roll5++) {
                for (let roll6 = 1; roll6 <= 3; roll6++) {
                  const playerTwoClone = clonePlayer(this.playerTwo);
                  playerTwoClone.move(roll4 + roll5 + roll6);
                  const newUniverse = new Universe(playerOneClone, playerTwoClone, this.multiplier);
                  universes.push(newUniverse);
                }
              }
            }
          }
        }
      }
      // destroy the current universe
      const universeIndex = universes.findIndex(u => u.id === this.id);
      universes.splice(universeIndex, 1);
    }

  }

  function clonePlayer(player: Player) {
    const newPlayer = Object.create(Object.getPrototypeOf(player));
    return Object.assign(newPlayer, player);
  }

  function resetUniverses(distinctUniverseCount: { [index: string]: number}) {
    const universes: Universe[] = [];
    Object.entries(distinctUniverseCount).forEach(([key, count]) => {
      const [p1, p2] = key.split('|');
      const [p1Score, p1Position] = p1.split(',').map(n => +n);
      const [p2Score, p2Position] = p2.split(',').map(n => +n);
      const playerOne = new Player(1, p1Score, p1Position);
      const playerTwo = new Player(2, p2Score, p2Position);
      universes.push(new Universe(playerOne, playerTwo, count));
    });
    return universes;
  }

  function tallyUniverses(universes: Universe[]) {
    console.log(`tallying ${universes.length} universes.`);
    const distinctUniverseCount: { [index: string]: number} = {};
    universes.forEach(u => {
      if (u.playerOne.winner()) {
        playerOneWins += u.multiplier;
        return;
      }
      if (u.playerTwo.winner()) {
        playerTwoWins += u.multiplier;
        return;
      }
      const key = `${u.playerOne.score},${u.playerOne.position}|${u.playerTwo.score},${u.playerTwo.position}`;
      if (!distinctUniverseCount[key]) {
        distinctUniverseCount[key] = 0;
      }
      distinctUniverseCount[key] += u.multiplier;
    });
    return distinctUniverseCount;
  }

  let universeNumber = 0;
  let distinctUniverseCounts: { [index: string]: number} = {};
  const playerOne = new Player(1, 0, puzzleInput[0]);
  const playerTwo = new Player(2, 0, puzzleInput[1]);
  let universes: Universe[] = [new Universe(playerOne, playerTwo, 1)];
  let playerOneWins = 0;
  let playerTwoWins = 0;

  while (universes.length > 0) {
    universes.forEach(u => {
      u.play();
    });
    distinctUniverseCounts = tallyUniverses(universes);
    universes = resetUniverses(distinctUniverseCounts);
  }

  console.log(universes.length, playerOneWins, playerTwoWins);
})();