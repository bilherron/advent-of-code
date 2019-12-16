import sys
import numpy as np

DEBUG = False
POS_MODE = 0
IMM_MODE = 1
REL_MODE = 2

class Computer:

    def __init__(self, instructions):
        self.memory = np.zeros(1024*1024, dtype=int)
        self.cmd = np.concatenate((np.array(instructions, dtype=int), self.memory))
        self.input_length = len(instructions)

    done = False
    pointer = 0
    relative_base = 0

    def compute(self, input_value):
        if DEBUG: print(f"=================Starting compute()=================")
        if self.done:
            return True
        new_input = True
        output = []
        cmd = self.cmd
        instruction = str(cmd[self.pointer]).zfill(5)
        opcode = int(instruction[3:])
        try:
            while opcode != 99:
                if DEBUG: print(f"Opcode is {opcode} ********************************")
                if DEBUG: print(f"Pointer is {self.pointer}")
                parameter_1 = cmd[self.pointer + 1]
                parameter_1_mode = int(instruction[2])
                parameter_2 = cmd[self.pointer + 2]
                parameter_2_mode = int(instruction[1])
                if DEBUG: print(f"Param 1 is {parameter_1} in mode {parameter_1_mode}")
                if DEBUG: print(f"Param 2 is {parameter_2} in mode {parameter_2_mode}")
                if opcode in [1,2,7,8]:
                    parameter_3 = cmd[self.pointer + 3]
                    parameter_3_mode = int(instruction[0])
                    if parameter_3_mode == POS_MODE:
                        write_location = parameter_3
                    elif parameter_3_mode == IMM_MODE:
                        # should not be possible
                        sys.exit()
                    elif parameter_3_mode == REL_MODE:
                        rel_index = self.relative_base + parameter_3
                        write_location = rel_index
                    if DEBUG: print(f"Param 3 is {parameter_3} in mode {parameter_3_mode}")


                if parameter_1_mode == POS_MODE:
                    value_1 = cmd[parameter_1]
                elif parameter_1_mode == IMM_MODE:
                    value_1 = parameter_1
                elif parameter_1_mode == REL_MODE:
                    rel_index = self.relative_base + parameter_1
                    value_1 = cmd[rel_index]

                if DEBUG: print(f"Value 1 is {value_1}")

                if opcode not in [3,4,9]:
                    if parameter_2_mode == POS_MODE:
                        value_2 = cmd[parameter_2]
                    elif parameter_2_mode == IMM_MODE:
                        value_2 = parameter_2
                    elif parameter_2_mode == REL_MODE:
                        rel_index = self.relative_base + parameter_2
                        value_2 = cmd[rel_index]
                    if DEBUG: print(f"Value 2 is {value_2}")

                if opcode == 1:
                    write_value = value_1 + value_2
                    cmd[write_location] = write_value
                    if DEBUG: print(f"Add {value_1} + {value_2}, write {write_value} to location {write_location}")
                    self.pointer += 4
                elif opcode == 2:
                    write_value = value_1 * value_2
                    cmd[write_location] = write_value
                    if DEBUG: print(f"Multiply {value_1} * {value_2}, write {write_value} to location {write_location}")
                    self.pointer += 4
                elif opcode == 3:
                    if new_input:
                        # entered_value = input("Enter input: ")
                        entered_value = input_value
                        if parameter_1_mode == POS_MODE:
                            cmd[parameter_1] = entered_value
                            if DEBUG: print(f"Write {entered_value} to location {parameter_1}")
                        elif parameter_1_mode == IMM_MODE:
                            # should not be possible
                            value_1 = parameter_1
                        elif parameter_1_mode == REL_MODE:
                            rel_index = self.relative_base + parameter_1
                            cmd[rel_index] = entered_value
                            if DEBUG: print(f"Write {entered_value} to location {rel_index}")
                        new_input = False
                        self.pointer += 2
                    else:
                        return output
                elif opcode == 4:
                    if DEBUG: print(f"Output {value_1}")
                    output.append(value_1)
                    # print(value_1)
                    if DEBUG: print(output)
                    self.pointer += 2
                elif opcode == 5:
                    if value_1 == 0:
                        self.pointer = self.pointer + 3
                    else:
                        self.pointer = value_2
                    if DEBUG: print(f"Moving pointer to {self.pointer}")
                elif opcode == 6:
                    self.pointer = value_2 if value_1 == 0 else self.pointer + 3
                    if DEBUG: print(f"Moving pointer to {self.pointer}")
                elif opcode == 7:
                    write_value = 1 if value_1 < value_2 else 0
                    cmd[write_location] = write_value
                    if DEBUG: print(f"Writing {write_value} to location {write_location}")
                    self.pointer += 4
                elif opcode == 8:
                    write_value = 1 if value_1 == value_2 else 0
                    cmd[write_location] = write_value
                    if DEBUG: print(f"Writing {write_value} to location {write_location}")
                    self.pointer += 4
                elif opcode == 9: # REL_BASE_ADJ
                    self.relative_base += value_1
                    if DEBUG: print(f"Adjust relative_base to {self.relative_base}")
                    self.pointer += 2
                else:
                    raise ValueError

                instruction = str(cmd[self.pointer]).zfill(5)
                opcode = int(instruction[3:])
                if DEBUG: print(cmd[0:self.input_length])
            if DEBUG: print(f"Opcode is {opcode}, completing program.")
            self.done = True
            return output
        except KeyboardInterrupt:
            sys.exit()
        except:
            print("Computer on fire.", self.pointer, opcode, sys.exc_info())
            print(cmd)
            sys.exit()


with open("input.txt") as fp:
    program = fp.read()

program = [int(n) for n in program.split(",")]
paint_bot = Computer(program)
if DEBUG: print(program)
hull_grid = np.zeros((200,200), dtype=int)
paint_color = 1
x_coord = 100
y_coord = 100
paint_bot_direction = "N"
painted = set()
DEBUG = False
BOT_DEBUG = False
while not paint_bot.done:
    (new_paint_color, turn) = paint_bot.compute(paint_color)
    hull_grid[y_coord, x_coord] = new_paint_color
    painted.add((x_coord, y_coord))
    if turn == 0:
        if paint_bot_direction == "N":
            x_coord -= 1
            paint_bot_direction = "W"
        elif paint_bot_direction == "S":
            x_coord += 1
            paint_bot_direction = "E"
        elif paint_bot_direction == "E":
            y_coord -= 1
            paint_bot_direction = "N"
        elif paint_bot_direction == "W":
            y_coord += 1
            paint_bot_direction = "S"
    elif turn == 1:
        if paint_bot_direction == "N":
            x_coord += 1
            paint_bot_direction = "E"
        elif paint_bot_direction == "S":
            x_coord -= 1
            paint_bot_direction = "W"
        elif paint_bot_direction == "E":
            y_coord += 1
            paint_bot_direction = "S"
        elif paint_bot_direction == "W":
            y_coord -= 1
            paint_bot_direction = "N"
    if BOT_DEBUG:
        print(f"Bot at facing {paint_bot_direction} at ({x_coord},{y_coord}) color is {paint_color}. Painting {new_paint_color} and moving {turn}.")
    paint_color = hull_grid[y_coord, x_coord]

np.set_printoptions(threshold=sys.maxsize)
print("Visited:", len(painted))
print(hull_grid)