import numpy as np

LAYER_PIXELS = 25 * 6
with open("input.txt") as fp:
    pixels = np.array([int(n) for n in fp.read()])
layers = pixels.reshape((100, 6, 25))

least_zeroes = LAYER_PIXELS
for i, layer in enumerate(layers):
    unique, counts = np.unique(layer, return_counts=True)
    layer_stats = dict(zip(unique, counts))
    zeroes = layer_stats[0]
    if zeroes < least_zeroes:
        least_zeroes = zeroes
        least_zeroes_layer = layer_stats

answer = least_zeroes_layer[1] * least_zeroes_layer[2]
print(f"The answer to the puzzle is {answer}")
