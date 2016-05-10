from kivy.garden.graph import Graph, MeshLinePlot, Plot
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label


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
            xmax=150000,
            ymin=0,
            ymax=2000,
            size=(1200, 800)
        )

        red = [1, 0, 0, 1]
        green = [0, 1, 0, 1]
        blue = [0, 0, 1, 1]

        self.orientation = 'vertical'
        self.add_widget(self.graph)

        self.plot = []
        # pareto front
        self.plot.append(MeshLinePlot(color=green))
        self.plot.append(MeshLinePlot(color=blue))
        self.plot[1]._set_mode('points')

        for plot in self.plot:
            self.graph.add_plot(plot)

    def add_datas(self, fronts):
        self.plot[0].points.clear()
        self.plot[1].points.clear()
        ## add first pareto front
        for individual in fronts[0].getIndividuals():
            self.plot[0].points.append((individual.getDistanceValue(), individual.getCostValue()))

        for i in range(1, len(fronts)):
            for individual in fronts[i].getIndividuals():
                self.plot[1].points.append((individual.getDistanceValue(), individual.getCostValue()))
