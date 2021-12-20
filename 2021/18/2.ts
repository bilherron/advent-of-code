import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8').split('\n')
const puzzleInput = readFileSync('./input.txt', 'utf-8').split('\n')

type SnailFishNumberPair = (number | number[])[];
type SnailFishNumber = (number | SnailFishNumberPair)[];
type FourthNestedPairObj = {
    indices: number[];
    value: string;
    leftIndices: number[];
    rightIndices: number[];
}

function add(n1: string, n2: string) {
  return `[${n1},${n2}]`;
}

function explode(sfNumberString: string, nestedPairIndiciesObj: FourthNestedPairObj) {
  let checkNumber = JSON.parse(sfNumberString);

  const [nestedPairLeft, nestedPairRight] = JSON.parse(nestedPairIndiciesObj.value);
  const nestedPairIndicies = nestedPairIndiciesObj.indices;

  const numberToLeft = getNumberAt(checkNumber, nestedPairIndiciesObj.leftIndices);
  if (numberToLeft >= 0) {
    let newNumberToLeft = numberToLeft + nestedPairLeft;
    
    setNumberAt(checkNumber, nestedPairIndiciesObj.leftIndices, newNumberToLeft);

  }

  const numberToRight = (nestedPairIndiciesObj.rightIndices.length > 0) ? getNumberAt(checkNumber, nestedPairIndiciesObj.rightIndices) : -1;
  if (numberToRight >= 0) {
    let newNumberToRight = numberToRight + nestedPairRight;
    setNumberAt(checkNumber, nestedPairIndiciesObj.rightIndices, newNumberToRight);
  }

  setNumberAt(checkNumber, nestedPairIndicies, 0);
  return JSON.stringify(checkNumber);
}

function getFourthNestedPair(sfNumberString: string) {
  const sfNumberArr = JSON.parse(sfNumberString);
  const result = { 
    indices: [] as number[], 
    value: '', 
    leftIndices: [] as number[], 
    rightIndices: [] as number[], 
  }
  let depth = 0;
  let nestedPair = '';
  let indices = [];
  for (let char of sfNumberString) {
    if (char === '[') {
      indices.push(0);
      depth += 1;
    }
    if (char === ']' && nestedPair.length === 0) {
      indices.pop();
      indices[indices.length - 1] = 1;
      depth -= 1;
    }
    if (char === ']' && nestedPair.length !== 0) {
      nestedPair += char;
      if (!result.value) {
        result.value = nestedPair;

        // we have our value. the value is either in a 0 or 1 position
        if (result.indices.reduce((acc, i) => acc + i, 0) === 0) {
          // the match value is in the left-most position
          result.leftIndices = [];
        } else {
          const leftIndices = [...result.indices];
          const lastIndexOfValue = leftIndices.pop();
          if (lastIndexOfValue === 1) {
            // if it's in the 1 position, go to its 0 position and descend into its 1s 
            // as far as you can go.
            leftIndices.push(0);
          } else {
            // if it's in the 0 position, backup until you hit a 1, change it to 0, then descend in its 1s as far as you can go
            while(leftIndices.pop() !== 1) {
              // keep going
            }
            leftIndices.push(0);
          }
          while (Array.isArray(getNumberAt(sfNumberArr, leftIndices))) {
            leftIndices.push(1);
          }
          const valueAtLeft = getNumberAt(sfNumberArr, leftIndices);
          result.leftIndices = [...leftIndices];
          // console.log(`found left value of ${valueAtLeft} at position`, result.leftIndices);
        }

        // we have our value. the value is either in a 0 or 1 position
        if (result.indices.every(i => i === 1)) {
          // the value is in the right-most position
          result.rightIndices = [];
        } else {
          const rightIndices = [...result.indices];
          const lastIndexOfValue = rightIndices.pop();
          if (lastIndexOfValue === 0) {
            // if it's in the 0 position, go to its 1 position and descend into its 0s 
            // as far as you can go.
            rightIndices.push(1);
          } else {
            // if it's in the 1 position, backup until you hit a 0, change it to 1, then descend in its 0s as far as you can go
            while(rightIndices.pop() !== 0) {
              // keep going
            }
            rightIndices.push(1);
          }
          while (Array.isArray(getNumberAt(sfNumberArr, rightIndices))) {
            rightIndices.push(0);
          }
          result.rightIndices = [...rightIndices];
        }


      }
      return result;
    }
    if (!Array.isArray(getNumberAt(sfNumberArr, indices))) {
      indices[indices.length - 1] = 1;
    }
    
    if (depth === 5) {
      nestedPair += char;
      if (result.indices.length === 0) {
        indices.pop();
        result.indices = [...indices];
      }
    }
  }
  return result;
}

function getNumberAt(sfNumber: SnailFishNumber, indices: number[]) {
  if (indices.length === 0) {
    return -1;
  }
  let returnNumber: SnailFishNumber | number = sfNumber;
  for (const index of indices) {
    try {
      returnNumber = returnNumber[index];
    } catch (e) {
      returnNumber = -1;
    }
  }
  return returnNumber;  
}

function setNumberAt(sfNumber: SnailFishNumber, indices: number[], newValue: number | number[]) {
  if (indices.length === 1) {
    sfNumber[indices[0]] = newValue;
  }
  if (indices.length === 2) {
    sfNumber[indices[0]][indices[1]] = newValue;
  }
  if (indices.length === 3) {
    sfNumber[indices[0]][indices[1]][indices[2]] = newValue;
  }
  if (indices.length === 4) {
    sfNumber[indices[0]][indices[1]][indices[2]][indices[3]] = newValue;
  } 
  if (indices.length === 5) {
    sfNumber[indices[0]][indices[1]][indices[2]][indices[3]][indices[4]] = newValue;
  } 
  if (indices.length === 6) {
    sfNumber[indices[0]][indices[1]][indices[2]][indices[3]][indices[4]][indices[5]] = newValue;
  } 
}


function findTenOrUpIndices(sfNumberString: string, initialIndices: number[], original: SnailFishNumber) {

  const checkNumber = JSON.parse(sfNumberString) as SnailFishNumber;
  let indices = [...initialIndices];
  let foundIt = false;
  checkNumber.forEach((item, index) => {
    const newInitialIndices = [...indices]
    newInitialIndices.push(index);
    if (!foundIt) {
      if (!Array.isArray(item) && item >= 10) {
        indices.push(index);
        foundIt = true;
      } else if (Array.isArray(item)) {
        const recursiveResult = findTenOrUpIndices(JSON.stringify(item), newInitialIndices, original);
        const testNumber = getNumberAt(original, recursiveResult);
        if (!Array.isArray(testNumber) && testNumber >= 10) {
          indices = recursiveResult;
          foundIt = true;
        } 
      }
    }
  });
  return indices;
}

function split(sfNumberString: string, indexOfValueToSplit: number[]) {
  const originalSplitNumber = JSON.parse(sfNumberString);
  let valueToSplit = getNumberAt(originalSplitNumber, indexOfValueToSplit) as number;
  const newLeftValue = Math.floor(valueToSplit / 2);
  const newRightValue = Math.ceil(valueToSplit / 2);
  setNumberAt(originalSplitNumber, indexOfValueToSplit, [newLeftValue, newRightValue]);
  return JSON.stringify(originalSplitNumber);
}

function reduceNumbers(input: string[]) {
  const final = input.reduce((acc, line) => {
    if (acc.length === 0) {
      // first line
      return line;
    }
    let newSnailFishNumber = add(acc, line);
    let keepGoing = true;
    while (keepGoing) {
      const fnp = getFourthNestedPair(newSnailFishNumber);
      const isThereFourthNestedPair = fnp.indices.length !== 0;
      if (isThereFourthNestedPair) {
        newSnailFishNumber = explode(newSnailFishNumber, fnp);
      } else {
        const tou = findTenOrUpIndices(newSnailFishNumber, [], JSON.parse(newSnailFishNumber));
        const isThereTenOrUp = tou.length > 0;
        if (isThereTenOrUp) {
          newSnailFishNumber = split(newSnailFishNumber, tou);
        } else {
          keepGoing = false;
        }
      }
    }
    return newSnailFishNumber;
  }, '');
  return final;
}

function getMagnitude(input: SnailFishNumber | number): number {
  if (!Array.isArray(input)) {
    return input;
  } else {
    const [left, right] = input;
    return 3 * getMagnitude(left) + 2 * getMagnitude(right);
  }
}

let maxMagnitude = 0;
for (const line of puzzleInput) {
  for (const line2 of puzzleInput) {
    if (line === line2) continue;
    const reduced = reduceNumbers([line, line2]);
    const magnitude = getMagnitude(JSON.parse(reduced));
    if (magnitude > maxMagnitude) maxMagnitude = magnitude;

    const reduced2 = reduceNumbers([line2, line]);
    const magnitude2 = getMagnitude(JSON.parse(reduced2));
    if (magnitude2 > maxMagnitude) maxMagnitude = magnitude2;
  }
}
console.log('maxMagnitude', maxMagnitude);