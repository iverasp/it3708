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
    qc.big_object_penalty,
    qc.no_wrap,
    qc.pull_mode,
    qc.timesteps
)
population = BeerTrackerPopulation(ea_config)

# ANN
ann_config = AnnConfig()
ann = CTRNN(ann_config, ea_config)
generation = 0
fittest_phenotype = ""
sim = BeerTrackerSimulator(ea_config)
evolver = BeerTrackerEvolve(ea_config)

for _ in range(qc.generations):
    evolver.evolve();

    # Terminal output
    generation += 1
    print("Generation: ", generation)
    highest_fitness = evolver.getHighestFitness;
    fittest_phenotype = evolver.getFittestPhenotype;
    print("Highest fitness: ", highest_fitness)
    average_fitness = evolver.getAverageFitness
    print("Average fitness: ", average_fitness)
    standard_deviation = evolver.getStandardDeviation
    print("Standard deviation: ", standard_deviation)

BeerTrackerGUI(ea_config, fittest_phenotype)
