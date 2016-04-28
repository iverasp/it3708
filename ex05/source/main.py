import distutils.util
import os.path
import sys
from read_citites import ReadCities
from quick_conf import QuickConf

# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = os.path.join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in sys.version_info[:2])
    ))
sys.path.append(os.path.abspath(libDir))

from dbindings import *

def main():

    rc = ReadCities("res/")
    print(len(rc.costs))

    qc = QuickConf()
    config = EaConfig(
        qc.generations,
        qc.population_size,
        qc.number_of_children,
        len(rc.costs),
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
        qc.big_object_bonus,
        qc.big_object_penalty,
        qc.small_object_bonus,
        qc.small_object_penalty,
        qc.no_wrap,
        qc.pull_mode,
        qc.timesteps
    )
    population = Population(config, len(rc.costs))


    for generation in range(config.getGenerations):
        print("Generation:", generation + 1)
        population.develop()
        population.evaluate()
        population.adultSelection()
        population.parentSelection()
        population.reproduce()


if __name__ == "__main__":
    main()
