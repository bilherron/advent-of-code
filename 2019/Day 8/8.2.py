import numpy as np

LAYER_PIXELS = 25 * 6
with open("input.txt") as fp:
    pixels = np.array([int(n) for n in fp.read()])
layers = pixels.reshape((100, 6, 25))

layers = np.flip(layers, 0)

final_image = layers[0].astype(str)
for layer in layers:
    for y in range(0,6):
        # print(y)
        for x in range(0,25):
            pixel = layer[y,x]
            if pixel in [0,1]:
                if pixel == 0:
                    pixel = "◼️"
                else:
                    pixel = "◻️"
                final_image[y,x] = str(pixel)

print(final_image)
