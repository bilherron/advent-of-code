import { readFileSync } from 'fs';

const puzzleInput = readFileSync('./input.txt', 'utf-8');

let exampleInput = '';
exampleInput = 'A0016C880162017C3686B18A3D4780';
// exampleInput = 'C0015000016115A2E0802F182340';
// exampleInput = '620080001611562C8802118E34';
// exampleInput = '8A004A801A8002F478';
// exampleInput = 'EE00D40C823060';
// exampleInput = '38006F45291200';
// exampleInput = 'D2FE28';

const input = puzzleInput;
let binaryString2 = '';
for (const hex of input) {
  binaryString2 += parseInt(hex, 16).toString(2).padStart(4, '0');
}
let versionNumberSum = 0;
processPacket(binaryString2);
console.log(`version sum ${versionNumberSum}`);


function processPacket(binString: string) {
  const returnValue = { value: 0, packetLength: 0 }
  let cursor = 0;
  
  const version = parseInt(binString.substring(cursor, cursor + 3), 2);
  cursor += 3;
  versionNumberSum += version;

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
    
    if (lengthTypeId === 0) {
      let remainingLength = parseInt(binString.substring(cursor, cursor + 15), 2);
      cursor += 15;
      while (remainingLength > 0) {
        const ret = processPacket(binString.substring(cursor));
        remainingLength -= ret.packetLength;
        cursor += ret.packetLength;
      }
    } else if (lengthTypeId === 1) {
      let length = parseInt(binString.substring(cursor, cursor + 11), 2);
      cursor += 11;
      for (let i = 1; i <= length; i++) {
        const ret = processPacket(binString.substring(cursor));
        cursor += ret.packetLength;
      }
    }
    returnValue.packetLength = cursor;
  }
  return returnValue;
}
