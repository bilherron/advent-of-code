def generate_orbit_chain(orbiter):

    if orbiter == "COM":
        return []

    orbit_chain = []
    orbitee = ""
    while orbitee != "COM":
        for orbit in orbits:
            if orbit[1] == orbiter:
                orbitee = orbit[0]
                orbit_chain.append(orbitee)
                break
        orbiter = orbitee
    return orbit_chain

def count_sub_orbits(orbiter):
    return len(generate_orbit_chain(orbiter))


orbits = []
with open("orbits.txt") as fp:
    orbits = [line.rstrip().split(")") for line in fp]

orbit_count = 0
for orbit in orbits:
    orbitee, orbiter = orbit
    orbit_count += count_sub_orbits(orbiter)

print(orbit_count)
