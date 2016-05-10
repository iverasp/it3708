from kivy.garden.graph import Graph, MeshLinePlot, Plot
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label

from random import random

class MTSPGraph(BoxLayout):
    def __init__(self):
        super(MTSPGraph, self).__init__()

        self.graph = Graph(
            xlabel="Distance",
            ylabel="Cost",
            x_ticks_minor=10000,
            x_ticks_major=50000,
            y_ticks_minor=250,
            y_ticks_major=500,
            y_grid_label=True,
            x_grid_label=True,
            padding=5,
            x_grid=True,
            y_grid=True,
            xmin=0,
            xmax=200000,
            ymin=0,
            ymax=2000,
            size=(1200, 800)
        )

        self.plot = []

        self.orientation = 'vertical'
        self.add_widget(self.graph)

    def generate_color(self, n):
        return [random() for _ in range(4)]

    def add_datas(self, fronts):
        green = [0, 1, 0, 1]
        for plot in self.plot:
            self.graph.remove_plot(plot)
        self.plot = []
        ## add first pareto front
        self.plot.append(MeshLinePlot(color=green))
        for individual in fronts[0].getIndividuals():
            self.plot[0].points.append((individual.getDistanceValue(), individual.getCostValue()))

        ## add all other fronts
        for i in range(1, len(fronts)):
            self.plot.append(MeshLinePlot(color=self.generate_color(i)))
            #self.plot[i]._set_mode('points')
            for individual in fronts[i].getIndividuals():
                self.plot[i].points.append((individual.getDistanceValue(), individual.getCostValue()))

        for plot in self.plot:
            self.graph.add_plot(plot)
