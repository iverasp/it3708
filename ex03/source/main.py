import distutils.util
#from flatland.flatland_gui import FlatlandGUI
import numpy as np
import os.path
from random import choice
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

"""
Program flow:
1. Generate weights (phenotype) with EA
2. Load weights into ANN
3. Simulate a run in Flatland
4. Evaluate fitness
5. Visualize the fittest weights
"""
# Generate random map
seed(1) # not random when testing
N = 10
# Make array of zeros
cells = np.zeros((N,N), dtype=np.int).tolist()
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
config = Config()
population = Population(config)
generation = 0

#ann = ANN()
#
#ann.setWeightsSynapsis0([[-1.68908207, -1.67388583,  4.00059522],
#                [ 2.40624477,  3.42700534, -5.52693725]]);
#
#ann.setWeightsSynapsis1([[-10.6303791 ],
#                [-12.34892854],
#                [ 11.61118677]])
#
#print(ann.predict([[1,0],[0,0],[0,0]]))

#ann = ANN()
#ann.learn(60000)

# Run EA
while True:
    population.develop()
    population.evaluate()
    population.adultSelection()
    population.parentSelection()
    population.reproduce()

    #highest_fitness = -99
    #fittest_sim = None
    #for i in range(2000):
    #    sim = Simulator(6, 6, cells, 60)
    #    while not sim.completed():
    #        move = choice([0,1,2]) # TODO: get move from ANN
    #        sim.move(move)
    #    print("Run", i + 1, "Fitness", sim.getFitness())
    #    if sim.getFitness() > highest_fitness:
    #        highest_fitness = sim.getFitness()
    #        fittest_sim = sim
    #print("Highest fitness:", fittest_sim.getFitness())

    highest_fitness = 0
    fittest_phenotype = ""

    print("Generation:", generation + 1)
    generation += 1
    for adult in population.getAdults:
        if adult.getFitness > highest_fitness:
            highest_fitness = adult.getFitness
            fittest_phenotype = adult.getPhenotype
    print("Highest fitness:", highest_fitness)
    print("Fittest phenotype:", fittest_phenotype)
    if (highest_fitness == 1.0): break

"""
# Get moves and visualize run
print("\nFinished intelligencing the artificial agent")
print("Visualizing run")
print("Press + or - to increase or decrease the speed")
print("Press escape to exit")
#moves = np.random.randint(3, size=1000)
#moves = [1,1,0,0,0,0,0,0,0,1,0,0,0]
GUI = FlatlandGUI(cells=cells, start=START, moves=fittest_sim.getMoves())
"""
