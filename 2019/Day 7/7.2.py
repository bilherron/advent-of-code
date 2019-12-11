import sys, io
from itertools import permutations

class Amplifier:

    def __init__(self, instructions, label, signal):
        self.cmd = instructions
        self.label = label
        print(f"Starting amplifier {label} with phase {signal}")
        self.compute(signal)

    done = False
    output = 0
    pointer = 0

    def compute(self, input_value):
        if self.done:
            return self.output
        new_input = True
        cmd = self.cmd
        instruction = str(cmd[self.pointer]).zfill(5)
        opcode = int(instruction[3:])
        try:
            while opcode != 99:
                parameter_1 = cmd[self.pointer + 1]
                parameter_1_mode = instruction[2]
                parameter_2 = cmd[self.pointer + 2]
                parameter_2_mode = instruction[1]
                if opcode in [1,2]:
                    parameter_3 = cmd[self.pointer + 3]
                    # parameter_3_mode = instruction[0] # should always be 0

                value_1 = cmd[parameter_1] if parameter_1_mode == "0" else parameter_1
                if opcode not in [3,4]:
                    value_2 = cmd[parameter_2] if parameter_2_mode == "0" else parameter_2

                if opcode == 1:
                    cmd[parameter_3] = value_1 + value_2
                    self.pointer += 4
                elif opcode == 2:
                    cmd[parameter_3] = value_1 * value_2
                    self.pointer += 4
                elif opcode == 3:
                    if new_input:
                        cmd[parameter_1] = int(input_value)
                        new_input = False
                        self.pointer += 2
                    else:
                        return self.output
                elif opcode == 4:
                    value_1 = cmd[parameter_1] if parameter_1_mode == "0" else parameter_1
                    self.output = value_1
                    self.pointer += 2
                elif opcode == 5:
                    if value_1 == 0:
                        self.pointer = self.pointer + 3
                    else:
                        self.pointer = value_2
                elif opcode == 6:
                    self.pointer = value_2 if value_1 == 0 else self.pointer + 3
                elif opcode == 7:
                    cmd[parameter_3] = 1 if value_1 < value_2 else 0
                    self.pointer += 4
                elif opcode == 8:
                    cmd[parameter_3] = 1 if value_1 == value_2 else 0
                    self.pointer += 4
                else:
                    raise ValueError

                instruction = str(cmd[self.pointer]).zfill(5)
                opcode = int(instruction[3:])

            self.done = True
            return self.output
        except KeyboardInterrupt:
            sys.exit()
        except:
            print("Computer on fire.", self.pointer, opcode, sys.exc_info())
            print(cmd)
            sys.exit()

with open("input.txt") as fp:
    amplifier_controller_software = [int(n) for n in fp.read().split(",")]

acs_test_3 = [int(n) for n in "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5".split(",")]
acs_test_4 = [int(n) for n in "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10".split(",")]

max_thrust = 0
amplifiers = ["A","B","C","D","E"]
thruster_signal_permutations = list(permutations(range(5, 10)))
# thruster_signal_permutations = [(9,7,8,5,6)]
for thruster_signals in thruster_signal_permutations:
    amplifier_array = []
    for i, amp in enumerate(amplifiers):
        amplifier_array.append(Amplifier(amplifier_controller_software[:], amp, thruster_signals[i]))

    next_input = 0
    while any([a.done == False for a in amplifier_array]):
        for amplifier in amplifier_array:
            next_input = amplifier.compute(next_input)

    # print(last_amplifier.output)
    best_signal = "1"
    if next_input > max_thrust:
        max_thrust = next_input
        best_signal = thruster_signals
print(best_signal, max_thrust)
