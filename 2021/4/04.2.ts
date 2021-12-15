import { readFileSync } from 'fs';

const getInput = function(day: number, test = false) {
  const filename = `${day.toString().padStart(2, '0')}.input${test ? '.test' : ''}.txt`;
  const puzzleInput = readFileSync(__dirname + `/${filename}`, 'utf-8');
  const boards = puzzleInput.split('\n\n');
  const boardArrays: number[][][] = [];
  boards.forEach((b) => {
    boardArrays.push(
      b.split('\n')
       .map(
         (row) => {
           return row.split(' ')
                     .filter(n => n !== '')
                     .map((n) => parseInt(n, 10));
         })
      );
  });
  return boardArrays;
}

const useTestData = false;
const boards = getInput(4, useTestData);
const markedBoards = boards.map(() => Array.from({length: 5}, () => Array.from({length: 5}, () => 0)));

let callString: string;
if (useTestData) {
  callString = '7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1'
} else {
  callString = '1,76,38,96,62,41,27,33,4,2,94,15,89,25,66,14,30,0,71,21,48,44,87,73,60,50,77,45,29,18,5,99,65,16,93,95,37,3,52,32,46,80,98,63,92,24,35,55,12,81,51,17,70,78,61,91,54,8,72,40,74,68,75,67,39,64,10,53,9,31,6,7,47,42,90,20,19,36,22,43,58,28,79,86,57,49,83,84,97,11,85,26,69,23,59,82,88,34,56,13'
}
const calledNumbers = callString.split(',').map(n => parseInt(n, 10));

function checkRow(boardNum: number, rowNum: number) {
  const rowSum = markedBoards[boardNum][rowNum].reduce((acc, square) => {
    return acc + square;
  }, 0);
  return rowSum === 5;
}

function checkCols(boardNum: number) {
  for (let i = 0; i < 5; i++) {
    let colSum = 0;
    markedBoards[boardNum].forEach((row) => {
      colSum += row[i];
    });
    if (colSum === 5) return true
  }
  return false;
}

let lastWinningBoard = -1;
let lastCalledNum = -1;
const nonWinningBoards: Set<number> = new Set(boards.keys());
calledNumbers.forEach((calledNumber) => {
  if (lastWinningBoard >= 0) return;
  boards.forEach((board, boardIndex) => {
    if (nonWinningBoards.has(boardIndex) === false) return;
    board.forEach((row: number[], rowIndex: number) => {
      row.forEach((square: number, squareIndex: number) => {
        if (square === calledNumber) {
          markedBoards[boardIndex][rowIndex][squareIndex] = 1;
        }
      })
      const rowIsBingo = checkRow(boardIndex, rowIndex);
      if (rowIsBingo) {
        if (nonWinningBoards.size === 1) {
          const remainingBoard = [...nonWinningBoards][0];
          if (remainingBoard === boardIndex) {
            lastWinningBoard = remainingBoard;
          }
        }
        nonWinningBoards.delete(boardIndex);
      }
    })
    const colIsBingo = checkCols(boardIndex);
    if (colIsBingo) {
      if (nonWinningBoards.size === 1) {
        const remainingBoard = [...nonWinningBoards][0];
        if (remainingBoard === boardIndex) {
          lastWinningBoard = remainingBoard;
        }
      }
      nonWinningBoards.delete(boardIndex);
    }
  })
  lastCalledNum = calledNumber;
});

const flatMarkedBoard = markedBoards[lastWinningBoard].flat();
const flatWinningBoard = boards[lastWinningBoard].flat();
const winningBoardSum = flatWinningBoard.reduce((acc: number, square: number, squareIndex: number) => {
  if (flatMarkedBoard[squareIndex] === 0) {
    return acc + square;
  }
  return acc;
}, 0);

console.log(`winningBoardSum ${winningBoardSum} * lastCalledNum ${lastCalledNum} = ${winningBoardSum * lastCalledNum}`);