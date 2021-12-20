import { readFileSync } from 'fs';

const exampleInput = readFileSync('./example.input.txt', 'utf-8');
const puzzleInput = readFileSync('./input.txt', 'utf-8');

const [algorithm, startImage] = puzzleInput.split('\n\n');

type Image = string[][];

function processCoord(image: Image, x: number, y: number, defaultPixel: string) {
  let surroundingValueString = '';
  for (let oy = -1; oy <= 1; oy++) {
    for (let ox = -1; ox <= 1; ox++) {
      try {
        surroundingValueString += image[y+oy][x+ox] || defaultPixel;
      } catch (e) {
        surroundingValueString += defaultPixel;
      }
    }
  }
  let values = surroundingValueString.replaceAll('.','0').replaceAll('#','1');
  const algorithmIndex = parseInt(values, 2);
  const newPixel = algorithm[algorithmIndex];
  return newPixel;
}

function padWith(image: Image, pixel: string) {
  const paddedRowLength = image[0].length + 4;
  let paddedImage = JSON.parse(JSON.stringify(image)) as Image;
  for (let i = 0; i < paddedImage.length; i++) {
    paddedImage[i].unshift(pixel);
    paddedImage[i].unshift(pixel);
    paddedImage[i].push(pixel);
    paddedImage[i].push(pixel);
  }
  paddedImage.unshift(Array(paddedRowLength).fill(pixel));
  paddedImage.unshift(Array(paddedRowLength).fill(pixel));
  paddedImage.push(Array(paddedRowLength).fill(pixel));
  paddedImage.push(Array(paddedRowLength).fill(pixel));
  
  return paddedImage;
}

function printImage(image: Image) {
  const maxX = image[0].length;
  console.log(' '.repeat(maxX+4));
  console.log(' '.repeat(maxX+4));
  image.forEach(row => {
    console.log(`  ${row.join('')}  `);
  });
  console.log(' '.repeat(maxX+4));
  console.log(' '.repeat(maxX+4));
  
}

function enhance(image: Image) {
  const paddedImage = padWith(image, infinitePixelsAre);
  const newImage = JSON.parse(JSON.stringify(paddedImage)) as Image;
  for (let y = 0; y < newImage.length; y++) {
    for (let x = 0; x < newImage[0].length; x++) {
      const processedPixel = processCoord(paddedImage, x, y, infinitePixelsAre);
      newImage[y][x] = processedPixel;
    }
  }
  if (infinitePixelsAre === '.') {
    infinitePixelsAre = allDarkReplacement;
  } else if (infinitePixelsAre === '#') {
    infinitePixelsAre = allLightReplacement;
  }
  return newImage;
}

function countLitPixels(image: Image) {
  return image.reduce((acc, row) => {
    return acc + row.reduce((acc2, pixel) => acc2 + (pixel === '#' ? 1 : 0), 0);
  }, 0);
}

let image = startImage.split('\n').map(line => {
  return line.split('');
})

const allDarkReplacement = algorithm[0];
const allLightReplacement = algorithm[511];
let infinitePixelsAre = '.';

// part 1
for (let i = 1; i <= 2; i++) {
  image = enhance(image);
}
console.log(countLitPixels(image));

// part 2
// reset image
image = startImage.split('\n').map(line => {
  return line.split('');
})
for (let i = 1; i <= 50; i++) {
  image = enhance(image);
}
console.log(countLitPixels(image));
// printImage(image);