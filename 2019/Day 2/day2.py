
def computer(input, noun, verb):
    input[1] = noun
    input[2] = verb
    pointer = 0
    opcode = input[pointer]
    try:
        while opcode != 99:
            parameter_1 = input[pointer + 1]
            parameter_2 = input[pointer + 2]
            write_location = input[pointer + 3]
            if opcode == 1:
                input[write_location] = input[parameter_1] + input[parameter_2]
            elif opcode == 2:
                input[write_location] = input[parameter_1] * input[parameter_2]
            else:
                raise ValueError
            pointer += 4
            opcode = input[pointer]
        return input[0]
    except:
        print("Computer on fire.", pointer, opcode)

memory = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,9,1,19,1,19,5,23,1,9,23,27,2,27,6,31,1,5,31,35,2,9,35,39,2,6,39,43,2,43,13,47,2,13,47,51,1,10,51,55,1,9,55,59,1,6,59,63,2,63,9,67,1,67,6,71,1,71,13,75,1,6,75,79,1,9,79,83,2,9,83,87,1,87,6,91,1,91,13,95,2,6,95,99,1,10,99,103,2,103,9,107,1,6,107,111,1,10,111,115,2,6,115,119,1,5,119,123,1,123,13,127,1,127,5,131,1,6,131,135,2,135,13,139,1,139,2,143,1,143,10,0,99,2,0,14,0]

desired_output = 19690720
for i in range(100):
    noun = i
    verb = 0
    output = computer(memory[:], noun, verb)
    if output > desired_output:
        noun = i - 1
        break
for i in range(100):
    verb = i
    output = computer(memory[:], noun, verb)
    if output == desired_output:
        break

answer = (100*noun)+verb
print("What is 100 * noun + verb?", answer)