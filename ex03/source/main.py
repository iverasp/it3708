import os.path, sys
import distutils.util
from flatland_gui import FlatlandGUI
import numpy as np
from random import choice, seed

# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = os.path.join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in sys.version_info[:2])
))
sys.path.append(os.path.abspath(libDir))
from population import Population, Individual

# Generate random map
seed(1) # not random when testing
N = 10
# Make array of zeros
cells = np.zeros((N,N), dtype=np.int)
# Generate a list of tuples of all array positions
places = [(x, y) for x in range(N) for y in range(N)]
START = (6, 6)
places.remove(START)

# FPD of (1/3, 1/3)
FOODITEMS = int(N*N*0.33)
POISONITEMS = int((N*N - FOODITEMS) * 0.33)

# Place food and the poison items in array. Remove places that has been used.
for food in range(FOODITEMS):
    pos = choice(places)
    cells[pos[0]][pos[1]] = 1
    places.remove(pos)
for poison in range(POISONITEMS):
    pos = choice(places)
    cells[pos[0]][pos[1]] = 2
    places.remove(pos)

# Setup EA
population = Population(100, 21)
gen = 0

# Run EA
while True:
    population.develop()
    population.evaluate()
    population.adultSelection()
    population.parentSelection()
    population.reproduce()

    highest_fitness = 0
    fittest_phenotype = ""

    print("Generation:", gen+1)
    gen += 1
    for adult in population.getAdults():
        if adult.getFitness() > highest_fitness:
            highest_fitness = adult.getFitness()
            fittest_phenotype = adult.getPhenotype()
    print("Highest fitness:", highest_fitness)
    print("Fittest phenotype:", fittest_phenotype)
    if (highest_fitness == 1.0): break

# Get moves and visualize run
print("\nFinished intelligencing the artificial agent")
print("Visualizing run")
print("Press escape to exit")
moves = np.random.randint(3, size=1000)
#moves = [1,1,1,1,1,1]
GUI = FlatlandGUI(cells=cells, start=START, moves=moves)
