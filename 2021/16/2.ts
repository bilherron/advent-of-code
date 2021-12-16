import { readFileSync } from 'fs';

const puzzleInput = readFileSync('./input.txt', 'utf-8');

let exampleInput = '';
exampleInput = '9C0141080250320F1802104A08'; // 1
exampleInput = '9C005AC2F8F0'; // 0
exampleInput = 'F600BC2D8F'; // 0
exampleInput = 'D8005AC2A8F0'; // 1
exampleInput = 'CE00C43D881120'; // 9
exampleInput = '880086C3E88112'; // 7
exampleInput = '04005AC33890'; // 54
exampleInput = 'C200B40A82'; // 3

const input = puzzleInput;
let binaryString = '';
for (const hex of input) {
  binaryString += parseInt(hex, 16).toString(2).padStart(4, '0');
}

let r = processPacket(binaryString);
console.log(r.value);


function processPacket(binString: string) {
  const returnValue = { value: 0, packetLength: 0 }
  let cursor = 0;
  const version = parseInt(binString.substring(cursor, cursor + 3), 2);
  cursor += 3;

  const typeId = parseInt(binString.substring(cursor, cursor + 3), 2);
  cursor += 3;

  if (typeId === 4) {
      // literal value
      let newBinaryString = '';
      let keepReading = '1';
      do {
        keepReading = binString.substring(cursor, cursor + 1)
        cursor += 1;
        newBinaryString += binString.substring(cursor, cursor + 4)
        cursor += 4;
      } while (keepReading === '1');
      returnValue.value = parseInt(newBinaryString, 2);
      returnValue.packetLength = cursor;
  } else {
    // operator
    const lengthTypeId = parseInt(binString.substring(cursor, cursor + 1), 2);
    cursor += 1;
    const returnedValues: number[] = [];
    if (lengthTypeId === 0) {
      let remainingBits = parseInt(binString.substring(cursor, cursor + 15), 2);
      cursor += 15;
      while (remainingBits > 0) {
        const ret = processPacket(binString.substring(cursor));
        returnedValues.push(ret.value);
        remainingBits -= ret.packetLength;
        cursor += ret.packetLength;
      }
    } else if (lengthTypeId === 1) {
      const numberOfPackets = parseInt(binString.substring(cursor, cursor + 11), 2);
      cursor += 11;
      for (let i = 1; i <= numberOfPackets; i++) {
        const ret = processPacket(binString.substring(cursor));
        returnedValues.push(ret.value);
        cursor += ret.packetLength;
      }
    }
    // process all returned values here
    switch (typeId) {
      case 0:
        returnValue.value = returnedValues.reduce((acc, v) => acc + v, 0);
        break;
      case 1:
        returnValue.value = returnedValues.reduce((acc, v) => acc * v, 1);
        break;
      case 2:
        returnValue.value = Math.min(...returnedValues);
        break;
      case 3:
        returnValue.value = Math.max(...returnedValues);
        break;
      case 4:
        // handled above
        break;
      case 5:
        returnValue.value = (returnedValues[0] > returnedValues[1]) ? 1 : 0;
        break;
      case 6:
        returnValue.value = (returnedValues[0] < returnedValues[1]) ? 1 : 0;
        break;
      case 7:
        returnValue.value = (returnedValues[0] === returnedValues[1]) ? 1 : 0;
        break;
    }

    returnValue.packetLength = cursor;
  }
  return returnValue;
}
