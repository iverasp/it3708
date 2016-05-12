from kivy.garden.graph import Graph, MeshLinePlot, Plot
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label

from random import random

class MTSPGraph(BoxLayout):

    green = [0, 1, 0, 1]
    blue = [0, 0, 1, 1]

    def __init__(self):
        super(MTSPGraph, self).__init__()

        self.graph = Graph(
            xlabel="Distance",
            ylabel="Cost",
            x_ticks_minor=0,
            x_ticks_major=10000,
            y_ticks_minor=0,
            y_ticks_major=100,
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
        self.plot.append(MeshLinePlot(color=self.green))
        self.plot.append(MeshLinePlot(color=self.blue))
        self.plot[0]._set_mode('points')
        self.plot[1]._set_mode('points')

        self.orientation = 'vertical'
        self.add_widget(self.graph)

    def generate_color(self, n):
        return [random() for _ in range(4)]

    def add_datas(self, fronts, end=False):
        if end:
            for plot in self.plot:
                self.graph.remove_plot(plot)
            self.plot = []
            ## add first pareto front
            self.plot.append(MeshLinePlot(color=self.green))
            self.plot[0]._set_mode('points')
        else:
            self.plot[0].points.clear()
            self.plot[1].points.clear()

        for individual in fronts[0].getIndividuals():
            self.plot[0].points.append((individual.getDistanceValue(), individual.getCostValue()))

        ## add all other fronts
        if end:
            for i in range(1, len(fronts)):
                self.plot.append(MeshLinePlot(color=self.generate_color(i)))
                self.plot[i]._set_mode('points')
                #self.plot[i]._set_mode('points')
                for individual in fronts[i].getIndividuals():
                    self.plot[i].points.append((individual.getDistanceValue(), individual.getCostValue()))
        else:
            for i in range(1, len(fronts)):
                for individual in fronts[i].getIndividuals():
                    self.plot[1].points.append((individual.getDistanceValue(), individual.getCostValue()))

        for plot in self.plot:
            self.graph.add_plot(plot)
