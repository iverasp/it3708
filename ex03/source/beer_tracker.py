from beer_tracker.beer_tracker_gui import BeerTrackerGUI
import distutils.util
import os.path
import sys
from random import randint
from quick_conf import QuickConf
import threading

# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = os.path.join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in sys.version_info[:2])
    ))
sys.path.append(os.path.abspath(libDir))

from dbindings import *

qc = QuickConf()
ea_config = EaConfig(
    qc.generations,
    qc.population_size,
    qc.number_of_children,
    qc.genotype_length,
    qc.adult_selection,
    qc.parent_selection,
    qc.tournament_epsilon,
    qc.tournament_group_size,
    qc.boltzmann_temperature,
    qc.boltzmann_delta_t,
    qc.crossover_rate,
    qc.children_per_pair,
    qc.mutation_type,
    qc.mutation_rate,
    qc.food_bonus,
    qc.poison_penalty,
    qc.small_object_bonus,
    qc.big_object_penalty
)
population = BeerTrackerPopulation(ea_config)

# ANN
ann_config = AnnConfig()
ann = CTRNN(ann_config)
generation = 0
fittest_phenotype = ""
captured_small_objects = 0
captured_big_objects = 0
#avoided_objects = 0

for _ in range(qc.generations):
    population.develop()

    for child in population.getChildren:
        synapsis0 = [child.getPhenotype[i:i+2]
                    for i in range(0, 16, 2)]
        time_constants_synapsis0 = [child.getPhenotype[i]
                    for i in range(16, 18)]
        gains_synapsis0 = [child.getPhenotype[i]
                    for i in range(18, 20)]

        synapsis1 = [child.getPhenotype[i:i+2]
                    for i in range(20, 30, 2)]
        time_constants_synapsis1 = [child.getPhenotype[i]
                    for i in range(30, 32)]
        gains_synapsis1 = [child.getPhenotype[i]
                    for i in range(32, 34)]

        ann.setWeightsSynapsis0(synapsis0)
        ann.setWeightsSynapsis1(synapsis1)
        ann.setGains0(gains_synapsis0)
        ann.setGains1(gains_synapsis1)
        ann.setTimeConstants0(time_constants_synapsis0)
        ann.setTimeConstants1(time_constants_synapsis1)

        sim = BeerTrackerSimulator(600)
        while not sim.completed():
            inputs = sim.getSensors()
            move = ann.getMove(inputs)
            sim.moveAgent(move[0], move[1])
        child.setCapturedSmallObjects = sim.getCapturedSmallObjects
        child.setCapturedBigObjects = sim.getCapturedBigObjects

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
            captured_small_objects = adult.getCapturedSmallObjects
            captured_big_objects = adult.getCapturedBigObjects
            #avoided_objects = adult.getCapturedSmallObjects
    print("Highest fitness: ", highest_fitness)
    average_fitness = population.getAverageFitness
    print("Captured small objects: ", captured_small_objects)
    print("Captured big objects: ", captured_big_objects)
    print("Average fitness: ", average_fitness)
    standard_deviation = population.getStandardDeviation
    print("Standard deviation: ", standard_deviation)

BeerTrackerGUI(600, fittest_phenotype)
