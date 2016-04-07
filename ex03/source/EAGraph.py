from kivy.garden.graph import Graph, MeshLinePlot
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label


class EAGraph(BoxLayout):
    def __init__(self):
        super(EAGraph, self).__init__()

        self.graph = Graph(
            xlabel="Generation",
            ylabel="Y",
            x_ticks_minor=5,
            x_ticks_major=25,
            y_ticks_minor=5,
            y_ticks_major=40,
            y_grid_label=True,
            x_grid_label=True,
            padding=5,
            x_grid=True,
            y_grid=True,
            xmin=0,
            xmax=120,
            ymin=0,
            ymax=200,
            size=(800, 600)
        )

        red = [1, 0, 0, 1]
        green = [0, 1, 0, 1]
        blue = [0, 0, 1, 1]

        self.cols = 2
        self.orientation = 'vertical'
        self.add_widget(self.graph)
        legends = BoxLayout()
        legends.orientation = 'horizontal'
        legends.add_widget(Label(text='Standard deviation', color=red, size=(100, 200)))
        legends.add_widget(Label(text='Average fitness', color=green, size=(100, 200)))
        legends.add_widget(Label(text='Highest fitness', color=blue, size=(100, 200)))
        self.add_widget(legends)

        self.plot = []
        self.plot.append(MeshLinePlot(color=red)) #X - Red
        self.plot.append(MeshLinePlot(color=green)) #Y - Green
        self.plot.append(MeshLinePlot(color=blue)) #Z - Blue

        for plot in self.plot:
            self.graph.add_plot(plot)

    def add_datas(self, datas, generation):
        for i in range(len(datas)):
            self.plot[i].points.append((generation, datas[i]))
