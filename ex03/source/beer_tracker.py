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

#fittest_phenotype = [-7.960783958435059, -6.392156600952148, -2.3333332538604736, -3.117647171020508, 2.058823585510254, 4.725490570068359, 3.9803924560546875, 3.3529415130615234, -0.843137264251709, 1.7058825492858887, -1.470588207244873, 2.56862735748291, 3.588235855102539, 3.313725471496582, -3.5098037719726562, -4.372549057006836, 1.5803921222686768, 1.9215686321258545, 1.1882352828979492, 4.419608116149902, -3.4509801864624023, -3.6470584869384766, 1.0392160415649414, -2.725490093231201, 3.0392160415649414, 4.529411315917969, -1.6666665077209473, 0.5686278343200684, -2.098039150238037, -2.2941174507141113, 1.1019607782363892, 1.8745098114013672, 4.435294151306152, 2.098039150238037]
BeerTrackerGUI(ea_config, fittest_phenotype)
