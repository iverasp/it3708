module dbindings;

import pyd.pyd;

import ea.population;
import ea.individual;
import flatland.agent;
import flatland.simulator;

public class DBindings { }

// PyD API

extern(C) void PydMain() {
    module_init();
    wrap_class!(
        Population,
        Init!(int, int),
        Def!(Population.generateInformation),
        Def!(Population.reproduce),
        Def!(Population.parentSelection),
        Def!(Population.adultSelection),
        Def!(Population.evaluate),
        Def!(Population.develop),
        Repr!(Population.toString),
        Def!(Population.getAdults)
    )();
    wrap_class!(
        Individual,
        Init!(int),
        Def!(Individual.getFitness),
        Def!(Individual.getPhenotype)
    )();
    wrap_class!(
        Agent,
        Init!(int, int),
        Def!(Agent.setX),
        Def!(Agent.setY),
        Def!(Agent.moveForward),
        Def!(Agent.turnRight),
        Def!(Agent.turnLeft),
        Def!(Agent.getX),
        Def!(Agent.getY),
        Def!(Agent.sense),
        Def!(Agent.getFoodsEaten),
        Def!(Agent.getPoisonsEaten)
    )();
    wrap_class!(
        Simulator,
        Init!(int, int, int[][], int),
        Def!(Simulator.completed),
        Def!(Simulator.move),
        Def!(Simulator.printStats),
        Def!(Simulator.getFitness),
        Def!(Simulator.getMoves)
    )();
}
