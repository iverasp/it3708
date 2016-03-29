module bindings;

import pyd.pyd;

import ea.population;
import ea.individual;
import flatland.agent;

public class Bindings { }

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
        Def!(Agent.getY)
    )();
}
