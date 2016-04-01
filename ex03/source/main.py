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

# FPD of (1/3, 1/3)
#FOODITEMS = int(N*N*0.33)
#POISONITEMS = int((N*N - FOODITEMS) * 0.33)

# Place food and the poison items in array. Remove places that has been used.
for place in places:
    if (random() > 0.33):
        cells[place[0]][place[1]] = 1
        places.remove(place)
for place in places:
    if (random() > 0.33):
        cells[place[0]][place[1]] = 2
        places.remove(place)

config = Config()
population = Population(config)

ann = ANN()
generation = 0

sim = None
bestsim = None
bestsimscore = -999999

for i in range(40):
    population.develop()

    for child in population.getChildren:
        synapsis0 = [child.getPhenotype[:3], child.getPhenotype[3:6]]
        ann.setWeightsSynapsis0(synapsis0)
        synapsis1 = [child.getPhenotype[x:x+1] for x in range(6,9)]
        ann.setWeightsSynapsis1(synapsis1)
        sim = Simulator(6,6, cells, 60)

        while not sim.completed():
            move = ann.getMove(sim.getAgent.sense(sim.getCells))
            sim.move(move)
        #print(child.getPhenotype)
        child.setDevouredFood = sim.getDevouredFood
        child.setDevouredPoison = sim.getDevouredPoison
        if sim.getDevouredFood * config.getFoodBonus - sim.getDevouredPoison * config.getPoisonPenalty > bestsimscore:
            bestsimscore = sim.getDevouredFood * config.getFoodBonus - sim.getDevouredPoison * config.getPoisonPenalty
            bestsim = sim

    population.evaluate()
    population.adultSelection()
    population.parentSelection()
    population.reproduce()

    # Terminal output
    highest_fitness = -9999999.0
    fittest_phenotype = ""
    print("Generation:", generation + 1)
    generation += 1
    for adult in population.getAdults:
        if adult.getFitness > highest_fitness:
            highest_fitness = adult.getFitness
            fittest_phenotype = adult.getPhenotype
    print("Highest fitness:", highest_fitness)
    #print("Fittest phenotype:", fittest_phenotype)
    #if (highest_fitness == 1.0): break

# Get moves and visualize run
print("\nFinished intelligencing the artificial agent")
print("Visualizing run")
print("Press + or - to increase or decrease the speed")
print("Press escape to exit")

print("Foods eaten:", bestsim.getDevouredFood, " / ", bestsim.getTotalFoods)
print("Poisons eaten:", bestsim.getDevouredPoison, "/", bestsim.getTotalPoisons)

GUI = FlatlandGUI(cells=cells, start=START, moves=bestsim.getMoves())
