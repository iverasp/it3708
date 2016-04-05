import distutils.util
from flatland.flatland_gui import FlatlandGUI
import numpy as np
import os.path
from random import choice, random
from random import seed
import sys
from kivy.app import App
from kivy.clock import Clock, mainthread
from EAGraph import EAGraph
from threading import Thread

# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = os.path.join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in sys.version_info[:2])
    ))
sys.path.append(os.path.abspath(libDir))

from dbindings import *

class Flatland(App):

    # EA
    ea_config = EaConfig()
    population = Population(ea_config)

    # ANN
    ann_config = AnnConfig()
    ann = ANN(ann_config)

    # EAGraph
    graph = EAGraph()

    # Simulator
    run_dynamic = True
    N = 10
    START = (6, 6)
    timesteps = 60

    generation = 0
    cells = None
    fittest_phenotype = ""

    def build(self):
        return self.graph

    def generate_map(self):
        # Generate random map
        #seed(1) # not random when testing

        # Make array of zeros
        cells = np.zeros((self.N, self.N), dtype=np.int).tolist()

        # Generate a list of tuples of all array positions
        places = [(x, y) for x in range(self.N) for y in range(self.N)]
        places.remove(self.START)

        # Place food and the poison items in array. Remove places that has been used.
        for place in places:
            if (random() > 0.33):
                cells[place[0]][place[1]] = 1
                places.remove(place)
        for place in places:
            if (random() > 0.33):
                cells[place[0]][place[1]] = 2
                places.remove(place)
        return cells

    def on_start(self):
        if not self.run_dynamic: cells = self.generate_map()
        Clock.schedule_once(self.evolve, 0)

    def evolve(self, *args):
        if self.run_dynamic: self.cells = self.generate_map()
        self.population.develop()

        for child in self.population.getChildren:
            synapsis0 = [child.getPhenotype[i:i+3]
                        for i in range(0, len(child.getPhenotype), 3)]
            #print("synapsis0: ", synapsis0)
            self.ann.setWeightsSynapsis0(synapsis0)
            sim = FlatlandSimulator(6, 6, self.cells, self.timesteps)

            while not sim.completed():
                move = self.ann.getMove(sim.getAgent.sense(sim.getCells))
                sim.move(move)
            child.setDevouredFood = sim.getDevouredFood
            child.setDevouredPoison = sim.getDevouredPoison

        self.population.evaluate()
        self.population.adultSelection()
        self.population.parentSelection()
        self.population.reproduce()

        # Terminal output
        self.generation += 1
        print("Generation: ", self.generation)
        highest_fitness = -sys.maxsize - 1
        for adult in self.population.getAdults:
            if adult.getFitness > highest_fitness:
                highest_fitness = adult.getFitness
                self.fittest_phenotype = adult.getPhenotype
        print("Highest fitness: ", highest_fitness)
        average_fitness = self.population.getAverageFitness
        print("Average fitness: ", average_fitness)
        standard_deviation = self.population.getStandardDeviation
        print("Standard deviation: ", standard_deviation)
        #print("Fittest phenotype:", fittest_phenotype)

        # Add datas to plot
        self.graph.add_datas(
            [standard_deviation, average_fitness, highest_fitness],
            self.generation
        )

        if not self.generation == self.ea_config.getGenerations:
            Clock.schedule_once(self.evolve, 0)
        else: self.run_flatland()

    def run_flatland(self):
        # Rerun the best result
        synapsis0 = [self.fittest_phenotype[i:i+3]
                    for i in range(0, len(self.fittest_phenotype), 3)]
        self.ann.setWeightsSynapsis0(synapsis0)
        sim = FlatlandSimulator(6, 6, self.cells, self.timesteps)
        while not sim.completed():
            move = self.ann.getMove(sim.getAgent.sense(sim.getCells))
            sim.move(move)

        # Get moves and visualize run
        print("\nFinished intelligencing the artificial agent")
        print("Visualizing run")
        print("Press + or - to increase or decrease the speed")
        print("Press escape to exit")
        print("Foods eaten:", sim.getDevouredFood, " / ", sim.getTotalFoods)
        print("Poisons eaten:", sim.getDevouredPoison, "/", sim.getTotalPoisons)
        GUI = FlatlandGUI(cells=self.cells, start=self.START, moves=sim.getMoves())

if __name__ == '__main__':
    Flatland().run()
