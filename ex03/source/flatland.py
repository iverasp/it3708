import distutils.util
import os.path
import sys
from flatland.flatland_gui import FlatlandGUI
import numpy as np
from random import choice, random
from random import seed
from kivy.app import App
from kivy.clock import Clock, mainthread
from EAGraph import EAGraph
from quick_conf import QuickConf

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
        qc.poison_penalty
    )
    population = Population(ea_config)

    # ANN
    ann_config = AnnConfig()
    ann = ANN(ann_config)

    # EAGraph
    graph = EAGraph()

    # Simulator
    run_dynamic = False
    random_runs = True
    scenarios = 1
    N = 10
    START = (6, 6)
    timesteps = 60

    generation = 0
    cells_list = []
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
        for scenario in range(self.scenarios):
            self.cells_list.append(self.generate_map())
        self.evolver = FlatlandEvolve(
            self.population,
            self.ann,
            self.ea_config.getGenerations,
            self.scenarios,
            self.cells_list,
            self.timesteps,
            self.run_dynamic
        )
        Clock.schedule_once(self.run_evolver, 0)
        #Clock.schedule_once(self.evolve, 0)

    def run_evolver(self, *args):
        self.evolver.evolve()
        self.generation += 1
        self.fittest_phenotype = self.evolver.getFittestPhenotype
        print("Generation: ", self.generation)
        highest_fitness = self.evolver.getHighestFitness
        print("Highest fitness: ", highest_fitness)
        average_fitness = self.population.getAverageFitness
        print("Average fitness: ", average_fitness)
        standard_deviation = self.population.getStandardDeviation
        print("Standard deviation: ", standard_deviation)
        #print("Fittest phenotype:", self.fittest_phenotype)

        # Add datas to plot
        self.graph.add_datas(
            [standard_deviation, average_fitness, highest_fitness],
            self.generation
        )

        if not self.generation == self.ea_config.getGenerations:
            Clock.schedule_once(self.run_evolver, 0)
        else: self.run_flatland()

    def evolve(self, *args):

        self.population.develop()

        for child in self.population.getChildren:
            synapsis0 = [child.getPhenotype[i:i+3]
                        for i in range(0, len(child.getPhenotype), 3)]
            #print("synapsis0: ", synapsis0)
            self.ann.setWeightsSynapsis0(synapsis0)
            for scenario in range(self.scenarios):
                current_scenario = np.copy(self.cells_list[scenario]).tolist()
                sim = FlatlandSimulator(6, 6, current_scenario, self.timesteps)
                while not sim.completed():
                    move = self.ann.getMove(sim.getAgent.sense(sim.getCells))
                    sim.move(move)
                child.addDevouredFood = sim.getDevouredFood
                child.addDevouredPoison = sim.getDevouredPoison
                if self.run_dynamic: self.cells_list[scenario] = self.generate_map()

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
        #print("Fittest phenotype:", self.fittest_phenotype)

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
        for scenario in range(self.scenarios):
            synapsis0 = [self.fittest_phenotype[i:i+3]
                        for i in range(0, len(self.fittest_phenotype), 3)]
            #self.cells = self.generate_map()
            self.ann.setWeightsSynapsis0(synapsis0)
            if not self.run_dynamic:
                sim_scenario = np.copy(self.cells_list[scenario]).tolist()
                gui_scenario = np.copy(sim_scenario).tolist()
            else:
                sim_scenario =  self.generate_map()
                gui_scenario = np.copy(sim_scenario).tolist()
            sim = FlatlandSimulator(6, 6, sim_scenario, self.timesteps)
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
            GUI = FlatlandGUI(cells=gui_scenario,
                                start=self.START, moves=sim.getMoves())

        while self.random_runs:
            synapsis0 = [self.fittest_phenotype[i:i+3]
                        for i in range(0, len(self.fittest_phenotype), 3)]
            self.ann.setWeightsSynapsis0(synapsis0)
            sim_scenario =  self.generate_map()
            gui_scenario = np.copy(sim_scenario).tolist()
            sim = FlatlandSimulator(6, 6, sim_scenario, self.timesteps)
            while not sim.completed():
                move = self.ann.getMove(sim.getAgent.sense(sim.getCells))
                sim.move(move)

            # Get moves and visualize run
            print("\nRunning random scenarios")
            print("Finished intelligencing the artificial agent")
            print("Visualizing run")
            print("Press + or - to increase or decrease the speed")
            print("Press escape to exit")
            print("Foods eaten:", sim.getDevouredFood, " / ", sim.getTotalFoods)
            print("Poisons eaten:", sim.getDevouredPoison, "/", sim.getTotalPoisons)
            GUI = FlatlandGUI(cells=gui_scenario,
                                start=self.START, moves=sim.getMoves())

if __name__ == '__main__':
    Flatland().run()
