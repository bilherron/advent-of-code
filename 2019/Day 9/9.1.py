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
    output = 0
    pointer = 0
    relative_base = 0

    def compute(self, input_value):
        if self.done:
            return self.output
        new_input = True
        cmd = self.cmd
        instruction = str(cmd[self.pointer]).zfill(5)
        opcode = int(instruction[3:])
        try:
            while opcode != 99:
                if DEBUG: print(f"Opcode is {opcode}")
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
                    # if new_input:
                    #     cmd[parameter_1] = int(input_value)
                    #     new_input = False
                    #     self.pointer += 2
                    # else:
                    #     return self.output
                    entered_value = input("Enter input: ")
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
                    self.pointer += 2
                elif opcode == 4:
                    if DEBUG: print(f"Output {value_1}")
                    # self.output = value_1
                    print(value_1)
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

            self.done = True
            # return self.output
        except KeyboardInterrupt:
            sys.exit()
        except:
            print("Computer on fire.", self.pointer, opcode, sys.exc_info())
            print(cmd)
            sys.exit()


with open("input.txt") as fp:
    program = fp.read()
test_program_1 = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
test_program_2 = "1102,34915192,34915192,7,4,7,99,0"
test_program_3 = "104,1125899906842624,99"

program = [int(n) for n in program.split(",")]
boost = Computer(program)
print(program)
boost.compute(1)