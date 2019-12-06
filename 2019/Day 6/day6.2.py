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

orbits = []
with open("orbits.txt") as fp:
    orbits = [line.rstrip().split(")") for line in fp]

you_chain = generate_orbit_chain("YOU")
san_chain = generate_orbit_chain("SAN")

you_distance_to_common_orbits = len([value for value in you_chain if value not in san_chain])
san_distance_to_common_orbits = len([value for value in san_chain if value not in you_chain])

print(you_distance_to_common_orbits + san_distance_to_common_orbits)

