import numpy as np

with open("map.txt") as fp:
    asteroid_map = np.array([[1 if char == '#' else 0 for char in line.strip()] for line in fp])

print(asteroid_map)
x_len, y_len = asteroid_map.shape

def get_surrounding_coords(origin_coord, coord_range, i):
    surrounding_coords = []
    (coord_x, coord_y) = origin_coord
    for point in range(-coord_range, (coord_range + 1)):
        check_x = coord_x + point
        if (check_x < 0 or check_x >= x_len):
            continue
        check_y = coord_y - i
        if not (check_y < 0 or check_y >= y_len):
            surrounding_coords.append((check_x,check_y))
        check_y = coord_y + i
        if not (check_y < 0 or check_y >= y_len):
            surrounding_coords.append((check_x,check_y))

    for point in range(-coord_range, (coord_range + 1)):
        check_y = coord_y + point
        if (check_y < 0 or check_y >= y_len):
            continue
        check_x = coord_x - i
        if not (check_x < 0 or check_x >= x_len):
            surrounding_coords.append((check_x,check_y))
        check_x = coord_x + i
        if not (check_x < 0 or check_x >= x_len):
            surrounding_coords.append((check_x,check_y))

    # de-dupe
    return list(set([c for c in surrounding_coords]))

def expanding_rings(coordinate):
    (coord_x, coord_y) = coordinate
    visible = 0
    for i in range(1,max(x_len, y_len)):
        ring_edge_length = (1 + (2 * i) )
        ring_edge_range = (ring_edge_length - 1) // 2
        surrounding_coords = get_surrounding_coords(coordinate, ring_edge_range, i)

        for x, y in surrounding_coords:
            if asteroid_map[y,x] == 0:
                continue
            # get distance between checked and coordinate
            (x_distance, y_distance) = tuple(np.subtract(coordinate, (x,y)))
            abs_x_distance = abs(x_distance)
            abs_y_distance = abs(y_distance)
            if abs_x_distance < 2 and abs_y_distance < 2:
                # adjacent asteroid
                visible += 1
            elif abs_x_distance == 1 or abs_y_distance == 1:
                # all that are 1 unit away are visible
                visible += 1
            elif abs_x_distance == abs_y_distance:
                # diagonals
                visible += 1
                for j in range(abs_x_distance - 1, 0, -1):
                    if x_distance > 0 and y_distance < 0: # up right
                        (check_x, check_y) = (coord_x - j, coord_y + j)
                    elif x_distance > 0 and y_distance > 0: # up left
                        (check_x, check_y) = (coord_x - j, coord_y - j)
                    elif x_distance < 0 and y_distance > 0: # down left
                        (check_x, check_y) = (coord_x + j, coord_y - j)
                    else: # x_distance < 0 and y_distance < 0: # down right
                        (check_x, check_y) = (coord_x + j, coord_y + j)

                    if asteroid_map[check_y,check_x] == 1:
                        visible -= 1
                        break
            elif x_distance == 0:
                visible += 1
                for j in range(abs_y_distance - 1 , 0, -1):
                    check_x = x
                    check_y = coord_y - j if y < coord_y else coord_y + j
                    if asteroid_map[check_y,check_x] == 1:
                        visible -= 1
                        break
            elif y_distance == 0:
                visible += 1
                for j in range(abs_x_distance - 1 , 0, -1):
                    check_y = y
                    check_x = coord_x - j if x < coord_x else coord_x + j
                    if asteroid_map[check_y,check_x] == 1:
                        visible -= 1
                        break
            else:
                visible += 1
                coords_to_check = []
                max_divisor = (max(x_len, y_len) // 2)
                for divisor in range(2, max_divisor + 1):
                    x_factor = abs_x_distance / divisor
                    y_factor = abs_y_distance / divisor
                    if not (x_factor.is_integer() and y_factor.is_integer()):
                        continue
                    for j in range(1,divisor):
                        if x_distance > 0 and y_distance < 0: # up right
                            (check_x, check_y) = (coord_x - (int(x_factor) * j), coord_y + (int(y_factor) * j))
                        elif x_distance > 0 and y_distance > 0: # up left
                            (check_x, check_y) = (coord_x - (int(x_factor) * j), coord_y - (int(y_factor) * j))
                        elif x_distance < 0 and y_distance > 0: # down left
                            (check_x, check_y) = (coord_x + (int(x_factor) * j), coord_y - (int(y_factor) * j))
                        else: # x_distance < 0 and y_distance < 0: # down right
                            (check_x, check_y) = (coord_x + (int(x_factor) * j), coord_y + (int(y_factor) * j))
                        coords_to_check.append((check_x, check_y))
                for check_x, check_y in coords_to_check:
                    if asteroid_map[check_y,check_x] == 1:
                        visible -= 1
                        break
    return visible

most_visible = 0
most_visible_coords = (-1,-1)
for y in range(0, y_len):
    for x in range(0, x_len):
        coordinate_value = asteroid_map[y,x]
        if coordinate_value == 0:
            # print("Empty space, next.")
            continue
        visible = expanding_rings((x,y))
        if visible > most_visible:
            most_visible = visible
            most_visible_coords = (x,y)

print(f"Location {most_visible_coords} is best with {most_visible} asteroids detected.")
