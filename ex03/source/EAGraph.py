from kivy.garden.graph import Graph, MeshLinePlot
from kivy.uix.boxlayout import BoxLayout
from math import sin

class EAGraph(BoxLayout):
    def __init__(self):
        super(EAGraph, self).__init__()

        self.graph = Graph(
            xlabel="Generation",
            ylabel="Y",
            x_ticks_minor=5,
            x_ticks_major=25,
            y_ticks_major=1,
            y_grid_label=True,
            x_grid_label=True,
            padding=5,
            x_grid=True,
            y_grid=True,
            xmin=0,
            xmax=60,
            ymin=0,
            ymax=40
        )
        self.add_widget(self.graph)

        self.plot = []
        self.plot.append(MeshLinePlot(color=[1, 0, 0, 1])) #X - Red
        self.plot.append(MeshLinePlot(color=[0, 1, 0, 1])) #Y - Green
        self.plot.append(MeshLinePlot(color=[0, 0, 1, 1])) #Z - Blue

        for plot in self.plot:
            self.graph.add_plot(plot)

    def add_datas(self, datas, generation):
        for i in range(len(datas)):
            self.plot[i].points.append((generation, datas[i]))
