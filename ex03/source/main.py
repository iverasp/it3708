import os.path, sys
import distutils.util

# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = os.path.join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in sys.version_info[:2])
))
sys.path.append(os.path.abspath(libDir))
from population import Population, Individual

population = Population(100, 21)

gen = 0

while True:
    population.develop()
    population.evaluate()
    population.adult_selection()
    population.parent_selection()
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
