import distutils.util
import os.path
import sys

from kivy.app import App
from kivy.clock import Clock, mainthread

from read_citites import ReadCities
from quick_conf import QuickConf
from MTSPGraph import MTSPGraph

# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = os.path.join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in sys.version_info[:2])
    ))
sys.path.append(os.path.abspath(libDir))

from dbindings import *

from kivy.config import Config
Config.set('graphics', 'width', '1200')
Config.set('graphics', 'height', '800')

class MTSP(App):

    graph = MTSPGraph()

    rc = ReadCities("res/")
    tsp = TSP(rc.distances, rc.costs)

    qc = QuickConf()
    config = EaConfig(
        qc.generations,
        qc.population_size,
        qc.number_of_children,
        len(rc.costs),
        qc.tournament_epsilon,
        qc.tournament_group_size,
        qc.crossover_rate,
        qc.children_per_pair,
        qc.mutation_rate,
    )
    population = Population(config, tsp)
    generation = 0

    def build(self):
        return self.graph

    def on_start(self):
        Clock.schedule_once(self.run_evolver, 0)

    def run_evolver(self, *args):
        self.generation += 1
        print("Generation:", self.generation)
        self.population.evaluate()
        self.population.reproduce()

        # Add datas to plot
        self.graph.add_datas(
            self.population.getFronts(),
            self.generation == self.qc.generations
        )

        if not self.generation == self.qc.generations:
            Clock.schedule_once(self.run_evolver, 0)
        else:
            print("Finished computing the computations in the computer")

if __name__ == "__main__":
    print("MOOP MTSP with MOEA")
    MTSP().run()
