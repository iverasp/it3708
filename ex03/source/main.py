import os.path, sys
import distutils.util
from flatland_gui import FlatlandGUI
import numpy as np

# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = os.path.join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in sys.version_info[:2])
))
sys.path.append(os.path.abspath(libDir))
from population import Population, Individual

# Generate random map
N = 10
cells = np.random.randint(3, size=(N, N)) # TODO: generate proper map

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
moves = [0,0,0,0,0,3,3,3,3,3,2,2,2,2,1,1,1,0,0,0] # TODO: get actual moves
GUI = FlatlandGUI(cells=cells, start=(N - 1, N - 1), moves=moves)
