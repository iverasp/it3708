import distutils.util
from flatland.flatland_gui import FlatlandGUI
import numpy as np
import os.path
from random import choice, random
from random import seed
import sys

# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = os.path.join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in sys.version_info[:2])
    ))
sys.path.append(os.path.abspath(libDir))

from dbindings import *

# Generate random map
#seed(1) # not random when testing
N = 10

# Make array of zeros
cells = np.zeros((N,N), dtype=np.int).tolist()

# Generate a list of tuples of all array positions
places = [(x, y) for x in range(N) for y in range(N)]
START = (6, 6)
places.remove(START)

# Place food and the poison items in array. Remove places that has been used.
for place in places:
    if (random() > 0.33):
        cells[place[0]][place[1]] = 1
        places.remove(place)
for place in places:
    if (random() > 0.33):
        cells[place[0]][place[1]] = 2
        places.remove(place)

# Initate objects for evolution
config = Config()
population = Population(config)
ann = ANN()
generation = 0
fittest_phenotype = ""

# Main loop
for i in range(30):
    population.develop()

    for child in population.getChildren:
        synapsis0 = [child.getPhenotype[i:i+3]
                    for i in range(0, len(child.getPhenotype), 3)]
        #print("synapsis0: ", synapsis0)
        ann.setWeightsSynapsis0(synapsis0)
        sim = Simulator(6, 6, cells, 60)

        while not sim.completed():
            move = ann.getMove(sim.getAgent.sense(sim.getCells))
            sim.move(move)
        child.setDevouredFood = sim.getDevouredFood
        child.setDevouredPoison = sim.getDevouredPoison

    population.evaluate()
    population.adultSelection()
    population.parentSelection()
    population.reproduce()

    # Terminal output
    generation += 1
    print("Generation: ", generation)
    highest_fitness = -sys.maxsize - 1
    for adult in population.getAdults:
        if adult.getFitness > highest_fitness:
            highest_fitness = adult.getFitness
            fittest_phenotype = adult.getPhenotype
    print("Highest fitness: ", highest_fitness)
    average_fitness = population.getAverageFitness
    print("Average fitness: ", average_fitness)
    standard_deviation = population.getStandardDeviation
    print("Standard deviation: ", standard_deviation)
    #print("Fittest phenotype:", fittest_phenotype)

# Rerun the best result
synapsis0 = [fittest_phenotype[i:i+3]
            for i in range(0, len(fittest_phenotype), 3)]
ann.setWeightsSynapsis0(synapsis0)
sim = Simulator(6, 6, cells, 60)
while not sim.completed():
    move = ann.getMove(sim.getAgent.sense(sim.getCells))
    sim.move(move)

# Get moves and visualize run
print("\nFinished evolving the artificial agent")
print("Visualizing run")
print("Press + or - to increase or decrease the speed")
print("Press escape to exit")
print("Foods eaten:", sim.getDevouredFood, " / ", sim.getTotalFoods)
print("Poisons eaten:", sim.getDevouredPoison, "/", sim.getTotalPoisons)
GUI = FlatlandGUI(cells=cells, start=START, moves=sim.getMoves())
