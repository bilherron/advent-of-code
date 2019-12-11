import sys, io
from itertools import permutations

def computer(cmd, label, inp_values=[]):
    # print(inp_values)
    input_values_index = 0
    # print("input_values_index", input_values_index)
    output = ""
    pointer = 0
    instruction = str(cmd[pointer]).zfill(5)
    opcode = int(instruction[3:])
    try:
        while opcode != 99:
            # print(pointer, instruction)
            # print(cmd)
            parameter_1 = cmd[pointer + 1]
            parameter_1_mode = instruction[2]
            parameter_2 = cmd[pointer + 2]
            parameter_2_mode = instruction[1]
            parameter_3 = cmd[pointer + 3]
            parameter_3_mode = instruction[0] # should always be 0

            value_1 = cmd[parameter_1] if parameter_1_mode == "0" else parameter_1
            if opcode not in [3,4]:
                value_2 = cmd[parameter_2] if parameter_2_mode == "0" else parameter_2

            if opcode == 1:
                cmd[parameter_3] = value_1 + value_2
                pointer += 4
            elif opcode == 2:
                cmd[parameter_3] = value_1 * value_2
                pointer += 4
            elif opcode == 3:
                try:
                    cmd[parameter_1] = int(inp_values[input_values_index])
                    input_values_index += 1
                except KeyError:
                    cmd[parameter_1] = int(input(f"Enter phase setting for amplifier {label}: "))
                pointer += 2
            elif opcode == 4:
                value_1 = cmd[parameter_1] if parameter_1_mode == "0" else parameter_1
                # print(value_1)
                output = value_1
                pointer += 2
            elif opcode == 5:
                pointer = pointer + 3 if value_1 == 0 else value_2
            elif opcode == 6:
                pointer = value_2 if value_1 == 0 else pointer + 3
            elif opcode == 7:
                cmd[parameter_3] = 1 if value_1 < value_2 else 0
                pointer += 4
            elif opcode == 8:
                cmd[parameter_3] = 1 if value_1 == value_2 else 0
                pointer += 4
            else:
                raise ValueError

            instruction = str(cmd[pointer]).zfill(5)
            opcode = int(instruction[3:])

        return output
    except KeyboardInterrupt:
        sys.exit()
    except:
        print("Computer on fire.", pointer, opcode, sys.exc_info()[0])
        print(cmd)

with open("input.txt") as fp:
    amplifier_controller_software = [int(n) for n in fp.read().split(",")]

acs_test_1 = [int(n) for n in "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0".split(",")]
acs_test_2 = [int(n) for n in "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0".split(",")]

max_thrust = 0
amplifiers = ["A","B","C","D","E"]
thruster_signal_permutations = list(permutations(range(0, 5)))
for thruster_signals in thruster_signal_permutations:
    out = 0
    for i, amp in enumerate(amplifiers):
        inp = [thruster_signals[i], out]
        out = computer(amplifier_controller_software[:], amp, inp)
    if out > max_thrust:
        max_thrust = out
        best_signal = thruster_signals
print(best_signal, max_thrust)