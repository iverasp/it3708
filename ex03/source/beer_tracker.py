from beer_tracker.beer_tracker_gui import BeerTrackerGUI
import distutils.util
import os.path
import sys
from random import randint
from quick_conf import QuickConf
import threading
import argparse

# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = os.path.join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in sys.version_info[:2])
    ))
sys.path.append(os.path.abspath(libDir))

from dbindings import *

parser = argparse.ArgumentParser()
parser.add_argument("--scenario", help="1 for wrap, 2 for pull, 3 for no-wrap")
args = parser.parse_args()

scenario = int(args.scenario)

if scenario == 1:
    big_object_bonus = 2.0
    big_object_penalty = 0.0
    small_object_bonus = 1.0
    small_object_penalty = 0.0
    no_wrap = False
    pull_mode = False
    genotype_length = 34 * 8
elif scenario == 2:
    big_object_bonus = 2.0
    big_object_penalty = 2.0
    small_object_bonus = 1.0
    small_object_penalty = 1.0
    no_wrap = False
    pull_mode = True
    genotype_length = 34 * 8
elif scenario == 3:
    big_object_bonus = 2.0
    big_object_penalty = 0.0
    small_object_bonus = 1.0
    small_object_penalty = 0.0
    no_wrap = True
    pull_mode = False
    genotype_length = 38 * 8

qc = QuickConf()
ea_config = EaConfig(
    qc.generations,
    qc.population_size,
    qc.number_of_children,
    genotype_length,
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
    big_object_bonus,
    big_object_penalty,
    small_object_bonus,
    small_object_penalty,
    no_wrap,
    pull_mode,
    qc.timesteps
)
population = BeerTrackerPopulation(ea_config)

# ANN
ann_config = AnnConfig()
ann = CTRNN(ann_config, ea_config)
generation = 0
fittest_phenotype = ""
avoided_big_objects = 0
avoided_small_objects = 0
captured_big_objects = 0
captured_small_objects = 0

"""
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
        child.setAvoidedBigObjects = sim.getAvoidedBigObjects
        child.setAvoidedSmallObjects = sim.getAvoidedSmallObjects
        child.setCapturedBigObjects = sim.getCapturedBigObjects
        child.setCapturedSmallObjects = sim.getCapturedSmallObjects

    population.evaluate()
    population.adultSelection()
    population.parentSelection()
    population.reproduce()

    # Terminal output
    generation += 1
    print("\nGeneration: ", generation)
    highest_fitness = -sys.maxsize - 1
    for adult in population.getAdults:
        if adult.getFitness > highest_fitness:
            highest_fitness = adult.getFitness
            fittest_phenotype = adult.getPhenotype
            avoided_big_objects = adult.getAvoidedBigObjects
            avoided_small_objects = adult.getAvoidedSmallObjects
            captured_big_objects = adult.getCapturedBigObjects
            captured_small_objects = adult.getCapturedSmallObjects
    print("Highest fitness: ", highest_fitness)
    average_fitness = population.getAverageFitness

"""
sim = BeerTrackerSimulator(ea_config)
evolver = BeerTrackerEvolve(ea_config)

for _ in range(qc.generations):
    evolver.evolve();

    # Terminal output
    generation += 1
    print("\nGeneration: ", generation)
    highest_fitness = evolver.getHighestFitness;
    print("Highest fitness: ", highest_fitness)
    avoided_big_objects = evolver.getAvoidedBigObjects
    print("Avoided big objects (+): ", avoided_big_objects)
    avoided_small_objects = evolver.getAvoidedSmallObjects
    print("Avoided small objects (-): ", avoided_small_objects)
    captured_big_objects = evolver.getCapturedBigObjects
    print("Captured big objects (-): ", captured_big_objects)
    captured_small_objects = evolver.getCapturedSmallObjects
    print("Captured small objects (+): ", captured_small_objects)
    average_fitness = evolver.getAverageFitness
    print("Average fitness: ", average_fitness)
    standard_deviation = evolver.getStandardDeviation
    print("Standard deviation: ", standard_deviation)
    fittest_phenotype = evolver.getFittestPhenotype;

BeerTrackerGUI(ea_config, fittest_phenotype)
