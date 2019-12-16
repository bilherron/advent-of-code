import sys
from itertools import permutations

class Moon:

    x_velocity = 0
    y_velocity = 0
    z_velocity = 0
    new_x_velocity = 0
    new_y_velocity = 0
    new_z_velocity = 0

    def __init__(self, name, coordinates):
        self.name = name
        (self.x_position, self.y_position, self.z_position) = coordinates

    def __str__(self):
        return f"pos=<x={self.x_position}, y={self.y_position}, z={self.z_position}>, vel=<x={self.x_velocity}, y={self.y_velocity}, z={self.z_velocity}, pot={self.potential_energy()}, kin={self.kinetic_energy()}>"

    def calculate_gravity(self, other_moon):
        for axis in ["x", "y", "z"]:
            current_position = getattr(self, f"{axis}_position")
            current_velocity = getattr(self, f"{axis}_velocity")
            new_velocity = getattr(self, f"new_{axis}_velocity")
            other_current_position = getattr(other_moon, f"{axis}_position")
            if DEBUG: print(f"{self.name} ({axis}): current_pos: {current_position}, current_velocity: {current_velocity}")
            if DEBUG: print(f"{other_moon.name} ({axis}): current_pos: {other_current_position}")
            if current_position < other_current_position:
                if DEBUG: print(f"setting new_{axis}_velocity to {new_velocity + 1}")
                setattr(self, f"new_{axis}_velocity", new_velocity + 1)
            if current_position > other_current_position:
                if DEBUG: print(f"setting new_{axis}_velocity to {new_velocity - 1}")
                setattr(self, f"new_{axis}_velocity", new_velocity - 1)

    def update_position(self):
        for axis in ["x", "y", "z"]:
            # apply gravity
            current_axis_position = getattr(self, f"{axis}_position")
            new_velocity = getattr(self, f"new_{axis}_velocity")
            setattr(self, f"{axis}_velocity", new_velocity)
            # apply velocity
            new_position = current_axis_position + new_velocity
            setattr(self, f"{axis}_position", new_position)

    def potential_energy(self):
        return abs(self.x_position) + abs(self.y_position) + abs(self.z_position)

    def kinetic_energy(self):
        return abs(self.x_velocity) + abs(self.y_velocity) + abs(self.z_velocity)

    def total_energy(self):
        return self.potential_energy() * self.kinetic_energy()


io = Moon("Io", (1, 3, -11))
europa = Moon("Europa", (17, -10, -8))
ganymede = Moon("Ganymede", (-1, -15, 2))
callisto = Moon("Callisto", (12, -4, -4))

moons = [io, europa, ganymede, callisto]
moon_permutations = permutations(moons, 2)
moon_pairs = list(moon_permutations)

DEBUG = False
time_steps = 1001
for time_step in range(1, time_steps):
    if DEBUG: print(f"---------------- Step {time_step} -------------")
    for moon_pair in moon_pairs:
        (moon, other_moon) = moon_pair
        moon.calculate_gravity(other_moon)

    for moon in moons:
        moon.update_position()
        print(str(moon))

total_energy = sum(moon.total_energy() for moon in moons)
print(total_energy)
